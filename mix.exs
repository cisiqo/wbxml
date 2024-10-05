defmodule Wbxml.MixProject do
  use Mix.Project

  def project do
    [
      app: :wbxml,
      version: "0.1.3",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :xmerl]
    ]
  end

  defp description() do
    "A wbxml library."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "wbxml",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README*  LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/cisiqo/wbxml"}
    ]
  end
end
