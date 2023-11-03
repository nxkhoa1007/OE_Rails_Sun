class DemoPartialsController < ApplicationController
  def new
    @zone = t("demo_partials.new.action")
    @date = Time.zone.today
  end

  def edit
    @zone = t("demo_partials.edit.action")
    @date = Time.zone.today - Settings.digit_5
  end
end
