defmodule RRulex.MixProject do
  use Mix.Project

  def project do
    [
      app: :rrulex,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "RRulex",
      source_url: "https://github.com/jakecurreri/rrulex",
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.18", only: :dev},
      {:timex, "~> 3.7.9"},
    ]
  end
end
