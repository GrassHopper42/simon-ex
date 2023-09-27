defmodule SimonWeb.MemberSessionControllerTest do
  use SimonWeb.ConnCase, async: true

  import Simon.HumanResourcesFixtures

  setup do
    %{member: member_fixture()}
  end

  describe "POST /members/log_in" do
    test "logs the member in", %{conn: conn, member: member} do
      conn =
        post(conn, ~p"/members/log_in", %{
          "member" => %{"email" => member.email, "password" => valid_member_password()}
        })

      assert get_session(conn, :member_token)
      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ member.email
      assert response =~ ~p"/members/settings"
      assert response =~ ~p"/members/log_out"
    end

    test "logs the member in with remember me", %{conn: conn, member: member} do
      conn =
        post(conn, ~p"/members/log_in", %{
          "member" => %{
            "email" => member.email,
            "password" => valid_member_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_simon_web_member_remember_me"]
      assert redirected_to(conn) == ~p"/"
    end

    test "logs the member in with return to", %{conn: conn, member: member} do
      conn =
        conn
        |> init_test_session(member_return_to: "/foo/bar")
        |> post(~p"/members/log_in", %{
          "member" => %{
            "email" => member.email,
            "password" => valid_member_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Welcome back!"
    end

    test "login following registration", %{conn: conn, member: member} do
      conn =
        conn
        |> post(~p"/members/log_in", %{
          "_action" => "registered",
          "member" => %{
            "email" => member.email,
            "password" => valid_member_password()
          }
        })

      assert redirected_to(conn) == ~p"/"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Account created successfully"
    end

    test "login following password update", %{conn: conn, member: member} do
      conn =
        conn
        |> post(~p"/members/log_in", %{
          "_action" => "password_updated",
          "member" => %{
            "email" => member.email,
            "password" => valid_member_password()
          }
        })

      assert redirected_to(conn) == ~p"/members/settings"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Password updated successfully"
    end

    test "redirects to login page with invalid credentials", %{conn: conn} do
      conn =
        post(conn, ~p"/members/log_in", %{
          "member" => %{"email" => "invalid@email.com", "password" => "invalid_password"}
        })

      assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Invalid email or password"
      assert redirected_to(conn) == ~p"/members/log_in"
    end
  end

  describe "DELETE /members/log_out" do
    test "logs the member out", %{conn: conn, member: member} do
      conn = conn |> log_in_member(member) |> delete(~p"/members/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :member_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the member is not logged in", %{conn: conn} do
      conn = delete(conn, ~p"/members/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :member_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end
  end
end
