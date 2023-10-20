class DemoPartialsController < ApplicationController
  def new
    @zone = t("demo_partials.new.action")
    @date = Date.today
  end

  def edit
    @zone = t("demo_partials.edit.action")
    @date = Date.today - 4
  end
end
