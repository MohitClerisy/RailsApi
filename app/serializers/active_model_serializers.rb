# frozen_string_literal: true

ActiveModel::Serializer.config.adapter = :json_api
ActiveModel::Serializer.config.default_includes = '**'
