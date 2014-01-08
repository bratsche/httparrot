defmodule HTTParrot.RedirectHandlerTest do
  use ExUnit.Case
  import :meck
  import HTTParrot.RedirectHandler

  setup do
    new :cowboy_req
  end

  teardown do
    unload :cowboy_req
  end

  test "malformed_request returns false if it's not an integer" do
    expect(:cowboy_req, :binding, [{[:n, :req1], {"a2B=", :req2}}])

    assert malformed_request(:req1, :state) == {true, :req2, :state}

    assert validate :cowboy_req
  end

  test "malformed_request returns false if it's an integer" do
    expect(:cowboy_req, :binding, [{[:n, :req1], {"2", :req2}}])

    assert malformed_request(:req1, :state) == {false, :req2, 2}

    assert validate :cowboy_req
  end

  test "malformed_request returns 1 if 'n' is less than 1" do
    expect(:cowboy_req, :binding, [{[:n, :req1], {"0", :req2}}])

    assert malformed_request(:req1, :state) == {false, :req2, 1}

    assert validate :cowboy_req
  end

  test "moved_temporarily returns 'redirect/n-1' if n > 1" do
    expect(:cowboy_req, :host_url, 1, {"host", :req2})

    assert moved_temporarily(:req1, 4) == {{true, "host/redirect/3"}, :req2, nil}

    assert validate :cowboy_req
  end

  test "moved_temporarily returns '/get' if n = 1" do
    expect(:cowboy_req, :host_url, 1, {"host", :req2})

    assert moved_temporarily(:req1, 1) == {{true, "host/get"}, :req2, nil}

    assert validate :cowboy_req
  end

end
