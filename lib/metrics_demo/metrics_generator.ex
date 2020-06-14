defmodule MetricsDemo.MetricsGenerator do
  use GenServer
  require OpenTelemetry.Span
  require OpenTelemetry.Tracer

  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  @impl GenServer
  def init(state) do
    schedule_work()

    {:ok, state}
  end

  @impl GenServer
  def handle_info(:work, state) do
    OpenTelemetry.Tracer.with_span "coordinating-work" do
      {duration, result_count} = :timer.tc(&do_work/0)

      OpenTelemetry.Span.set_attributes([{"duration", duration}, {"result_count", result_count}])

      :telemetry.execute([:metrics_demo, :work_completed], %{
        duration: duration,
        result_count: result_count
      })

      schedule_work()
    end

    {:noreply, state}
  end

  defp do_work do
    OpenTelemetry.Tracer.with_span "doing-work" do
      span_ctx = OpenTelemetry.Tracer.current_span_ctx()

      1..10
      |> Task.async_stream(fn id -> fan_out(id, span_ctx) end)
      |> Enum.to_list()

      fn -> do_more_work(span_ctx) end
      |> Task.async()
      |> Task.await()

      work()
      result_count = Enum.random(0..100)

      result_count
    end
  end

  defp do_more_work(span_ctx) do
    OpenTelemetry.Tracer.with_span "doing-more-work", %{parent: span_ctx} do
      work()
    end
  end

  defp fan_out(id, span_ctx) do
    OpenTelemetry.Tracer.with_span "fan-out-work-#{id}", %{parent: span_ctx} do
      work()
    end
  end

  defp schedule_work do
    OpenTelemetry.Tracer.with_span "scheduling-next-work" do
      # 2 seconds
      Process.send_after(self(), :work, 2 * 1000)
    end
  end

  defp work do
    0..10
    |> Enum.random()
    |> Process.sleep()
  end
end
