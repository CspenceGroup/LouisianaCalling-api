# config/initializers/lazyload.rb
Lazyload::Rails.configure do |config|
  config.placeholder = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAdIAAAFdCAMAAACAWBwJAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyNpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6QzY3NzczMjM4RDFCMTFFM0I2Q0VGRUUwNjhGMUNEMEIiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6QzY3NzczMjI4RDFCMTFFM0I2Q0VGRUUwNjhGMUNEMEIiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChNYWNpbnRvc2gpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6QTREQjcxMDU4Q0UxMTFFM0I2Q0VGRUUwNjhGMUNEMEIiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6QTREQjcxMDY4Q0UxMTFFM0I2Q0VGRUUwNjhGMUNEMEIiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz6iWH1qAAAAdVBMVEUAAAAAAAAW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"
end

