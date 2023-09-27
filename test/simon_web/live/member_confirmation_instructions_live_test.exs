defmodule SimonWeb.MemberConfirmationInstructionsLiveTest do
  use SimonWeb.ConnCase

  import Phoenix.LiveViewTest
  import Simon.HumanResourcesFixtures

  alias Simon.HumanResources
  alias Simon.Repo

  setup do
    %{member: member_fixture()}
  end

  describe "Resend confirmation" do
    test "renders the resend confirmation page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/members/confirm")
      assert html =~ "Resend confirmation instructions"
    end

    test "sends a new confirmation token", %{conn: conn, member: member} do
      {:ok, lv, _html} = live(conn, ~p"/members/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", member: %{email: member.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.get_by!(HumanResources.MemberToken, member_id: member.id).context == "confirm"
    end

    test "does not send confirmation token if member is confirmed", %{conn: conn, member: member} do
      Repo.update!(HumanResources.Member.confirm_changeset(member))

      {:ok, lv, _html} = live(conn, ~p"/members/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", member: %{email: member.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      refute Repo.get_by(HumanResources.MemberToken, member_id: member.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/members/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", member: %{email: "unknown@example.com"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.all(HumanResources.MemberToken) == []
    end
  end
end
