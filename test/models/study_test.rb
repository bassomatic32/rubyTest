require 'test_helper'

class StudyTest < ActiveSupport::TestCase

  test 'should enforce height / weight presence' do
  	study = Study.new
	assert_not study.valid?

	assert_equal [:weight,:height], study.errors.keys

	study = studies(:one)
	assert study.valid?


  end

  test 'should restrict values of "likes" field' do
  	study = studies(:one)
	study.likes = 'Ferrets'

	assert_not study.valid?

	study.likes = 'cats'
	assert study.valid?

	study.likes = 'dogs'
	assert study.valid?

  end

  test 'should allow "likes" field to be blank' do
  	study = studies(:one)
	study.likes = nil

	assert study.valid?
  end
end
