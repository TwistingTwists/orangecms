defmodule OrangeCmsWeb.ProjectLiveTest do
  use OrangeCmsWeb.ConnCase

  import OrangeCms.ProjectsFixtures
  import Phoenix.LiveViewTest

  @create_attrs %{github_config: %{}, image: "some image", name: "some name", setup_completed: true, type: "some type"}
  @update_attrs %{
    github_config: %{},
    image: "some updated image",
    name: "some updated name",
    setup_completed: false,
    type: "some updated type"
  }
  @invalid_attrs %{github_config: nil, image: nil, name: nil, setup_completed: false, type: nil}

  defp create_project(_) do
    project = project_fixture()
    %{project: project}
  end

  describe "Index" do
    setup [:create_project]

    test "lists all projects", %{conn: conn, project: project} do
      {:ok, _index_live, html} = live(conn, ~p"/projects")

      assert html =~ "Listing Projects"
      assert html =~ project.image
    end

    test "saves new project", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/projects")

      assert index_live |> element("a", "New Project") |> render_click() =~
               "New Project"

      assert_patch(index_live, ~p"/projects/new")

      assert index_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#project-form", project: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/projects")

      html = render(index_live)
      assert html =~ "Project created successfully"
      assert html =~ "some image"
    end

    test "updates project in listing", %{conn: conn, project: project} do
      {:ok, index_live, _html} = live(conn, ~p"/projects")

      assert index_live |> element("#projects-#{project.id} a", "Edit") |> render_click() =~
               "Edit Project"

      assert_patch(index_live, ~p"/projects/#{project}/edit")

      assert index_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#project-form", project: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/projects")

      html = render(index_live)
      assert html =~ "Project updated successfully"
      assert html =~ "some updated image"
    end

    test "deletes project in listing", %{conn: conn, project: project} do
      {:ok, index_live, _html} = live(conn, ~p"/projects")

      assert index_live |> element("#projects-#{project.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#projects-#{project.id}")
    end
  end

  describe "Show" do
    setup [:create_project]

    test "displays project", %{conn: conn, project: project} do
      {:ok, _show_live, html} = live(conn, ~p"/projects/#{project}")

      assert html =~ "Show Project"
      assert html =~ project.image
    end

    test "updates project within modal", %{conn: conn, project: project} do
      {:ok, show_live, _html} = live(conn, ~p"/projects/#{project}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Project"

      assert_patch(show_live, ~p"/projects/#{project}/show/edit")

      assert show_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#project-form", project: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/projects/#{project}")

      html = render(show_live)
      assert html =~ "Project updated successfully"
      assert html =~ "some updated image"
    end
  end
end
