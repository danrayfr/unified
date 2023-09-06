# frozen_literal_string: true

class QaTemplatesController < ApplicationController
  before_action :set_template, only: %i[show edit update]
  before_action :set_account, only: %i[show new create edit update]

  def index
    @templates = QaTemplate.all
  end

  def show; end

  def new
    @template = @account.qa_templates.build
    @template.build_note
  end

  def create
    @template = @account.qa_templates.build(template_params)

    # Populate the metrics
    @template.metrics = populate_metrics

    if @template.save
      redirect_to account_qa_template_path(@account, @template), notice: 'Template saved'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @template.metrics = populate_metrics

    respond_to do |format|
      if @template.update(template_params)
        @template.save
        format.html { redirect_to account_qa_template_path(@account, @template), notice: 'Template updated.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_template
    @template = QaTemplate.find(params[:id])
  end

  def template_params
    params.require(:qa_template).permit(:name, :published, :account_id, metrics: [], note_attributes: %i[id content])
  end

  def populate_metrics
    metrics = []
    params[:metric_name]&.each_with_index do |metric_name, index|
      deduction = params[:deduction][index]
      description = params[:description][index]
      metric = { metric_name:, deduction:, description: }
      metrics << metric
    end

    metrics
  end
end
