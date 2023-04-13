defmodule OrangeCms.Projects do
  use Ash.Api

  resources do
    registry(OrangeCms.Projects.Registry)
  end

  authorization do
    authorize :by_default
  end
end
