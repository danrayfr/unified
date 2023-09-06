class CoachingTemplatesController < ApplicationController
  before_action :set_account
  before_action :set_coaching_template, only: %i[show edit update destroy]

  def index
    @templates = @account.coaching_templates
  end

  def show; end

  def new
    @coaching_template = @account.coaching_templates.build
    @coaching_template.build_note
  end

  def create
    @coaching_template = @account.coaching_templates.build(template_params)

    respond_to do |format|
      if @coaching_template.save
        format.html { redirect_to account_coaching_templates_path(@account, @coaching_template), notice: 'Coaching template created.' } # rubocop:disable Layout/LineLength
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @coaching_template.update(template_params)
        format.html { redirect_to account_coaching_template_path(@account, @coaching_template), notice: 'Coaching template updated.' } # rubocop:disable Layout/LineLength
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @coaching_template.destroy
        format.html do
          redirect_to account_coaching_template_path(@account),
                      notice: 'Coaching template successfully deleted!'
        end
      end
    end
  end

  private

  def set_coaching_template
    @coaching_template = CoachingTemplate.find(params[:id])
  end

  def template_params
    params.require(:coaching_template).permit(:name, :published, :account_id, note_attributes: %i[id content])
  end
end
