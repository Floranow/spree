require 'spec_helper'

describe "Tax Rates", type: :feature, js: true do
  stub_authorization!

  let!(:tax_rate) { create(:tax_rate, calculator: stub_model(Spree::Calculator)) }

  before do
    visit spree.admin_path
    click_link "Configuration"
  end

  # Regression test for #535
  it "can see a tax rate in the list if the tax category has been deleted" do
    tax_rate.tax_category.destroy
    expect { click_link "Tax Rates" }.not_to raise_error
    within(:xpath, all("table tbody td")[2].path) do
      expect(page).to have_content("N/A")
    end
  end

  # Regression test for #1422
  it "can create a new tax rate" do
    click_link "Tax Rates"
    click_link "New Tax Rate"
    fill_in "Rate", with: "0.05"
    click_button "Create"
    expect(page).to have_content("Tax Rate has been successfully created!")
  end
end
