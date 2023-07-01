defmodule OrangeCmsWeb.Components.Card do
  @moduledoc """
  Implement of card components from https://ui.shadcn.com/docs/components/card
  """
  use Phoenix.Component

  @doc """
  Card component

  ## Examples:

        <.card>
          <.card_header>
            <.card_title>Card title</.card_title>
            <.card_descroption>Card subtitle</.card_description>
          </.card_header>
          <.card_content>
            Card text
          </.card_content>
          <.card_footer>
            <.button>Button</.button>
          </.card_footer>
        </.card>
  """
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def card(assigns) do
    ~H"""
    <div class={["rounded-xl border bg-card text-card-foreground shadow", @class]}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def card_header(assigns) do
    ~H"""
    <div class={["flex flex-col space-y-1.5 p-6", @class]}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def card_title(assigns) do
    ~H"""
    <h3 class={["font-semibold leading-none tracking-tight", @class]}>
      <%= render_slot(@inner_block) %>
    </h3>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def card_description(assigns) do
    ~H"""
    <p class={["text-sm text-muted-foreground", @class]}>
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def card_content(assigns) do
    ~H"""
    <div class={["p-6 pt-0", @class]}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def card_footer(assigns) do
    ~H"""
    <div class={["flex items-center justify-between p-6 pt-0 ", @class]}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
