enum ContentLoadState<Value> {
    case loading
    case loaded(Value)
    case failed(String)
}
