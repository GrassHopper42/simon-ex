defmodule SimonWeb.MemberSessionController do
  use SimonWeb, :controller

  alias Simon.HumanResources
  alias SimonWeb.MemberAuth

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully!")
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:member_return_to, ~p"/members/settings")
    |> create(params, "비밀번호가 변경되었습니다.")
  end

  def create(conn, params) do
    create(conn, params, "로그인 되었습니다.")
  end

  defp create(conn, %{"member" => member_params}, info) do
    %{"phone_number" => phone_number, "password" => password} = member_params

    if member = HumanResources.get_member_by_phone_number_and_password(phone_number, password) do
      conn
      |> put_flash(:info, info)
      |> MemberAuth.log_in_member(member, member_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the phone_number is registered.
      conn
      |> put_flash(:error, "전화번호나 비밀번호를 다시 확인해주세요.")
      |> put_flash(:phone_number, String.slice(phone_number, 0, 160))
      |> redirect(to: ~p"/login")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "로그아웃 되었습니다.")
    |> MemberAuth.log_out_member()
  end
end
