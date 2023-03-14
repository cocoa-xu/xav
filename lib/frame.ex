defmodule Xav.Frame do
  @moduledoc """
  Module representing video frame.
  """

  @type t() :: %__MODULE__{
          data: binary(),
          width: non_neg_integer(),
          height: non_neg_integer(),
          pts: integer()
        }

  defstruct [
    :data,
    :width,
    :height,
    :pts
  ]

  @spec new(binary(), non_neg_integer(), non_neg_integer(), integer()) :: t()
  def new(data, width, height, pts) do
    %__MODULE__{
      data: data,
      width: width,
      height: height,
      pts: pts
    }
  end

  @spec to_nx(t()) :: Nx.Tensor.t()
  def to_nx(%__MODULE__{} = frame) do
    frame.data
    |> Nx.from_binary(:u8)
    |> Nx.reshape({frame.height, frame.width, 3})
  end
end
