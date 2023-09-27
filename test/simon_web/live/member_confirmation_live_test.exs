defmodule SimonWeb.MemberConfirmationLiveTest do
  use SimonWeb.ConnCase

  import Phoenix.LiveViewTest
  import Simon.HumanResourcesFixtures

  alias Simon.HumanResources
  alias Simon.Repo

  setup do
    %{member: member_fixture()}
  end

  describe "Confirm member" do
    test "renders confirmation page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/members/confirm/some-token")
      assert html =~ "Confirm Account"
    end

    test "confirms the given token once", %{conn: conn, member: member} do
      token =
        extract_member_token(fn url ->
          HumanResources.deliver_member_confirmation_instructions(member, url)
        end)

      {:ok, lv, _html} = live(conn, ~p"/members/confirm/#{token}")

      result =
        lv
        |> form("#confirmation_form")
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert {:ok, conn} = result

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "Member confirmed successfully"

      assert HumanResources.get_member!(member.id).confirmed_at
      refute get_session(conn, :member_token)
      assert Repo.all(HumanResources.MemberToken) == []

      # when not logged in
      {:ok, lv, _html} = live(conn, ~p"/members/confirm/#{token}")

      result =
        lv
        |> form("#confirmation_form")
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert {:ok, conn} = result

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "Member confirmation link is invalid or it has expired"

      # when logged in
      {:ok, lv, _html} =
        build_conn()
        |> log_in_member(member)
        |> live(~p"/members/confirm/#{token}")

      result =
        lv
        |> form("#confirmation_form")
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert {:ok, conn} = result
      refute Phoenix.Flash.get(conn.assigns.flash, :error)
    end

    test "does not confirm email with invalid token", %{conn: conn, member: member} do
      {:ok, lv, _html} = live(conn, ~p"/members/confirm/invalid-token")

      {:ok, conn} =
        lv
        |> form("#confirmation_form")
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "Member confirmation link is invalid or it has expired"

      refute HumanResources.get_member!(member.id).confirmed_at
    end
  end
end
