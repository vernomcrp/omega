defmodule Omega.Mixfile do
  use Mix.Project

  @version "0.1.1"

  def project do
    [
      app: :omega,
      version: @version,
      elixir: "~> 1.3",
      description: "Module wrapper for making Omise API clients.",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      docs: [extras: ["README.md"]],
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :inets, :ssl]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:poison, "~> 2.2 or ~> 3.0"},

      # Dev dependencies
      {:earmark, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.13", only: :dev},

      # Test dependencies
      {:mock, "~> 0.2", only: :test},
    ]
  end

  def package do
    [
      files: ~w(lib mix.exs),
      maintainers: ["Teerawat Lamanchart"],
      licenses: ~w(MIT),
      links: %{"GitHub" => "https://github.com/teerawat1992/omega"},
    ]
  end
end
