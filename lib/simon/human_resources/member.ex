defmodule Simon.HumanResources.Member do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Simon.HumanResources.Member

  schema "members" do
    field :name, :string
    field :birthday, :date
    field :phone_number, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :naive_datetime

    timestamps()
  end

  @doc """
  A member changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.

    * `:validate_email` - Validates the uniqueness of the email, in case
      you don't want to validate the uniqueness of the email (like when
      using this changeset for validations on a LiveView form before
      submitting the form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(%Member{} = member, attrs \\ %{}, opts \\ []) do
    member
    |> cast(attrs, [:name, :birthday, :phone_number])
    |> validate_name()
    |> validate_birthday()
    |> validate_phone_number(opts)
    |> set_default_password(opts)
  end

  defp set_default_password(changeset, opts) do
    changeset
    |> put_change(:password, generate_password(changeset))
    |> maybe_hash_password(opts)
  end

  defp generate_password(changeset) do
    changeset
    |> get_change(:birthday, Date.utc_today())
    |> Date.to_string()
    |> String.split("-")
    |> Enum.join()
  end

  defp validate_name(changeset) do
    changeset
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 5)
    |> validate_format(:name, ~r/[가-힣]+$/)
  end

  defp validate_birthday(changeset) do
    changeset
    |> validate_required([:birthday])
    |> validate_over_18()
    |> validate_under_65()
  end

  defp shift_year(%Date{:year => year} = date, years) do
    {year + years, date.month, date.day}
  end

  defp validate_over_18(changeset) do
    validate_change(changeset, :birthday, fn :birthday, birthday ->
      if Date.utc_today() |> shift_year(-18) |> Date.before?(birthday) do
        [birthday: "18세 이상이어야 합니다"]
      else
        []
      end
    end)
  end

  defp validate_under_65(changeset) do
    validate_change(changeset, :birthday, fn :birthday, birthday ->
      if Date.utc_today() |> shift_year(-65) |> Date.after?(birthday) do
        [birthday: "65세 이하이어야 합니다"]
      else
        []
      end
    end)
  end

  defp validate_phone_number(changeset, opts) do
    changeset
    |> validate_required([:phone_number])
    |> validate_format(:phone_number, ~r/^\d{11}$/, message: "11자리 숫자만 입력 가능합니다")
    |> validate_length(:phone_number, is: 11, message: "11자리 숫자만 입력 가능합니다")
    |> maybe_validate_unique_phone_number(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 20)
    # Examples of additional password validation:
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      # Hashing could be done with `Ecto.Changeset.prepare_changes/2`, but that
      # would keep the database transaction open longer and hurt performance.
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp maybe_validate_unique_phone_number(changeset, opts) do
    if Keyword.get(opts, :validate_phone_number, true) do
      changeset
      |> unsafe_validate_unique(:phone_number, Simon.Repo, message: "이미 등록된 전화번호입니다")
      |> unique_constraint(:phone_number)
    else
      changeset
    end
  end

  @doc """
  A member changeset for changing the phone_number.

  It requires the email to change otherwise an error is added.
  """
  def phone_number_changeset(member, attrs, opts \\ []) do
    member
    |> cast(attrs, [:phone_number])
    |> validate_phone_number(opts)
    |> case do
      %{changes: %{phone_number: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :phone_number, "did not change")
    end
  end

  @doc """
  A member changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(member, attrs, opts \\ []) do
    member
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(member) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(member, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no member or the member doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Simon.HumanResources.Member{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end
