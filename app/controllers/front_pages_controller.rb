class FrontPagesController < ApplicationController
	layout "frontpage"
 skip_before_filter :authenticate_user!
  def home

  end

  def features
  end

  def help_doc
  end
end
