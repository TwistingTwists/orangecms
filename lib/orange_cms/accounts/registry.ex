defmodule OrangeCms.Accounts.Registry do
  use Ash.Registry,
    extensions: [
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry(OrangeCms.Accounts.User)
  end
end