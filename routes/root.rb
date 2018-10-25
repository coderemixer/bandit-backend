ROOT_ROUTE = proc do
  get '' do
    yajl :root
  end
end
