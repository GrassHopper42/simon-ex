defmodule Simon.HumanResources do
  @moduledoc """
  The HumanResources context.
  """

  import Ecto.Query, warn: false
  alias Simon.Repo

  alias Simon.HumanResources.{Member, MemberToken}

  ## Database getters

  @doc """
  Gets a member by phone_number.

  ## Examples

      iex> get_member_by_phone_number("foo@example.com")
      %Member{}

      iex> get_member_by_phone_number("unknown@example.com")
      nil

  """
  def get_member_by_phone_number(phone_number) when is_binary(phone_number) do
    Repo.get_by(Member, phone_number: phone_number)
  end

  @doc """
  Gets a member by phone_number and password.

  ## Examples

      iex> get_member_by_phone_number_and_password("foo@example.com", "correct_password")
      %Member{}

      iex> get_member_by_phone_number_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_member_by_phone_number_and_password(phone_number, password)
      when is_binary(phone_number) and is_binary(password) do
    member = Repo.get_by(Member, phone_number: phone_number)
    if Member.valid_password?(member, password), do: member
  end

  @doc """
  Gets a single member.

  Raises `Ecto.NoResultsError` if the Member does not exist.

  ## Examples

      iex> get_member!(123)
      %Member{}

      iex> get_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_member!(id), do: Repo.get!(Member, id)

  ## Member registration

  @doc """
  Registers a member.

  ## Examples

      iex> register_member(%{field: value})
      {:ok, %Member{}}

      iex> register_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_member(attrs) do
    %Member{}
    |> Member.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking member changes.

  ## Examples

      iex> change_member_registration(member)
      %Ecto.Changeset{data: %Member{}}

  """
  def change_member_registration(%Member{} = member, attrs \\ %{}) do
    Member.registration_changeset(member, attrs,
      hash_password: false,
      validate_phone_number: false
    )
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the member phone_number.

  ## Examples

      iex> change_member_phone_number(member)
      %Ecto.Changeset{data: %Member{}}

  """
  def change_member_phone_number(member, attrs \\ %{}) do
    Member.phone_number_changeset(member, attrs, validate_phone_number: false)
  end

  @doc """
  Emulates that the phone_number will change without actually changing
  it in the database.

  ## Examples

      iex> apply_member_phone_number(member, "valid password", %{phone_number: ...})
      {:ok, %Member{}}

      iex> apply_member_phone_number(member, "invalid password", %{phone_number: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_member_phone_number(member, password, attrs) do
    member
    |> Member.phone_number_changeset(attrs)
    |> Member.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the member phone_number using the given token.

  If the token matches, the member phone_number is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_member_phone_number(member, token) do
    context = "change:#{member.phone_number}"

    with {:ok, query} <- MemberToken.verify_change_phone_number_token_query(token, context),
         %MemberToken{sent_to: phone_number} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(member_phone_number_multi(member, phone_number, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp member_phone_number_multi(member, phone_number, context) do
    changeset =
      member
      |> Member.phone_number_changeset(%{phone_number: phone_number})
      |> Member.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:member, changeset)
    |> Ecto.Multi.delete_all(:tokens, MemberToken.member_and_contexts_query(member, [context]))
  end

  @doc ~S"""
  Delivers the update phone_number instructions to the given member.

  ## Examples

      iex> deliver_member_update_phone_number_instructions(member, current_phone_number, &url(~p"/members/settings/confirm_phone_number/#{&1})")
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_member_update_phone_number_instructions(
        %Member{} = member,
        current_phone_number,
        update_phone_number_url_fun
      )
      when is_function(update_phone_number_url_fun, 1) do
    {_encoded_token, member_token} =
      MemberToken.build_phone_number_token(member, "change:#{current_phone_number}")

    Repo.insert!(member_token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the member password.

  ## Examples

      iex> change_member_password(member)
      %Ecto.Changeset{data: %Member{}}

  """
  def change_member_password(member, attrs \\ %{}) do
    Member.password_changeset(member, attrs, hash_password: false)
  end

  @doc """
  Updates the member password.

  ## Examples

      iex> update_member_password(member, "valid password", %{password: ...})
      {:ok, %Member{}}

      iex> update_member_password(member, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_member_password(member, password, attrs) do
    changeset =
      member
      |> Member.password_changeset(attrs)
      |> Member.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:member, changeset)
    |> Ecto.Multi.delete_all(:tokens, MemberToken.member_and_contexts_query(member, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{member: member}} -> {:ok, member}
      {:error, :member, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_member_session_token(member) do
    {token, member_token} = MemberToken.build_session_token(member)
    Repo.insert!(member_token)
    token
  end

  @doc """
  Gets the member with the given signed token.
  """
  def get_member_by_session_token(token) do
    {:ok, query} = MemberToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_member_session_token(token) do
    Repo.delete_all(MemberToken.token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc ~S"""
  Delivers the confirmation phone_number instructions to the given member.

  ## Examples

      iex> deliver_member_confirmation_instructions(member, &url(~p"/members/confirm/#{&1}"))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_member_confirmation_instructions(confirmed_member, &url(~p"/members/confirm/#{&1}"))
      {:error, :already_confirmed}

  """
  def deliver_member_confirmation_instructions(%Member{} = member, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if member.confirmed_at do
      {:error, :already_confirmed}
    else
      {_encoded_token, member_token} = MemberToken.build_phone_number_token(member, "confirm")
      Repo.insert!(member_token)
    end
  end

  @doc """
  Confirms a member by the given token.

  If the token matches, the member account is marked as confirmed
  and the token is deleted.
  """
  def confirm_member(token) do
    with {:ok, query} <- MemberToken.verify_phone_number_token_query(token, "confirm"),
         %Member{} = member <- Repo.one(query),
         {:ok, %{member: member}} <- Repo.transaction(confirm_member_multi(member)) do
      {:ok, member}
    else
      _ -> :error
    end
  end

  defp confirm_member_multi(member) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:member, Member.confirm_changeset(member))
    |> Ecto.Multi.delete_all(:tokens, MemberToken.member_and_contexts_query(member, ["confirm"]))
  end

  ## Reset password

  @doc ~S"""
  Delivers the reset password phone_number to the given member.

  ## Examples

      iex> deliver_member_reset_password_instructions(member, &url(~p"/members/reset_password/#{&1}"))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_member_reset_password_instructions(%Member{} = member, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {_encoded_token, member_token} =
      MemberToken.build_phone_number_token(member, "reset_password")

    Repo.insert!(member_token)
  end

  @doc """
  Gets the member by reset password token.

  ## Examples

      iex> get_member_by_reset_password_token("validtoken")
      %Member{}

      iex> get_member_by_reset_password_token("invalidtoken")
      nil

  """
  def get_member_by_reset_password_token(token) do
    with {:ok, query} <- MemberToken.verify_phone_number_token_query(token, "reset_password"),
         %Member{} = member <- Repo.one(query) do
      member
    else
      _ -> nil
    end
  end

  @doc """
  Resets the member password.

  ## Examples

      iex> reset_member_password(member, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %Member{}}

      iex> reset_member_password(member, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_member_password(member, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:member, Member.password_changeset(member, attrs))
    |> Ecto.Multi.delete_all(:tokens, MemberToken.member_and_contexts_query(member, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{member: member}} -> {:ok, member}
      {:error, :member, changeset, _} -> {:error, changeset}
    end
  end
end
