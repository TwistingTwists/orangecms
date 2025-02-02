defmodule OrangeCmsWeb.ProjectLive.FormComponent do
  @moduledoc false
  use OrangeCmsWeb, :live_component

  alias OrangeCms.Projects

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form
        class="space-y-6"
        for={@form}
        id="project-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.form_item field={@form[:name]} label="What is your project's name?">
          <Input.input field={@form[:name]} type="text" phx-debounce="500" />
        </.form_item>
        <div class="flex w-full flex-row-reverse">
          <.button icon="inbox_arrow_down" phx-disable-with="Saving...">
            Save project
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{project: project} = assigns, socket) do
    changeset = Projects.change_project(project)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset =
      socket.assigns.project
      |> Projects.change_project(project_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"project" => project_params}, socket) do
    save_project(socket, socket.assigns.action, project_params)
  end

  defp save_project(socket, :new, project_params) do
    case Projects.create_project(project_params) do
      {:ok, project} ->
        notify_parent({:saved, project})

        {:noreply,
         socket
         |> put_flash(:info, "Project created successfully")
         |> push_navigate(to: ~p"/p/#{project.code}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
