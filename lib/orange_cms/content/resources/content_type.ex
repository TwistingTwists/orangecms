defmodule OrangeCms.Content.ContentType do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table("content_types")
    repo(OrangeCms.Repo)

    custom_indexes do
      index(["id", "project_id"], unique: true)
    end
  end

  code_interface do
    define_for(OrangeCms.Content)
    define(:create, action: :create)
    define(:read_all, action: :read_all)
    define(:update, action: :update)
    define(:delete, action: :destroy)
    define(:get, args: [:id], action: :by_id)
    define(:get_by_key, args: [:key], action: :by_key)
  end

  actions do
    defaults([:create, :read, :update, :destroy])

    read :read_all do
      prepare(build(sort: [inserted_at: :desc]))
    end

    read :by_id do
      argument(:id, :uuid, allow_nil?: false)
      get?(true)
      filter(expr(id == ^arg(:id)))
    end

    read :by_key do
      argument(:key, :string, allow_nil?: false)
      get?(true)
      filter(expr(key == ^arg(:key)))
    end
  end

  alias OrangeCms.Content.FieldDef
  alias OrangeCms.Content.ImageUploadSettings

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      allow_nil?(false)
    end

    attribute :key, :string do
      allow_nil?(false)
    end

    attribute :image_settings, ImageUploadSettings do
      default(%{})
      allow_nil?(true)
    end

    attribute :github_config, :map do
      default(%{})
    end

    attribute :field_defs, {:array, FieldDef} do
      default([])
      constraints(load: [:options])
    end

    attribute :anchor_field, :string do
      allow_nil?(true)
    end

    create_timestamp(:inserted_at)
    update_timestamp(:updated_at)
  end

  # relationships do
  #   belongs_to :project, Project do
  #     attribute_type(:string)
  #     allow_nil?(false)
  #     attribute_writable?(true)
  #     api(OrangeCms.Projects)
  #   end
  # end

  policies do
    bypass action_type(:read) do
      authorize_if actor_present()
    end

    policy always() do
      authorize_if actor_attribute_equals(:role, :admin)
    end
  end
end
