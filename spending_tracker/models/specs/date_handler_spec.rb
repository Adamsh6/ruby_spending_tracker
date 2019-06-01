require('minitest/autorun')
require('minitest/rg')
require('date')
require_relative('../date_handler.rb')


 class TestDateHandler < Minitest::Test

   def test_last_six_months
     actual = ['2019-06', '2019-05', '2019-04', '2019-03', '2019-02', '2019-01']
     assert_equal(actual, DateHandler.last_six_months)
   end

   def test_compare_month
     assert_equal(0, DateHandler.compare_month('2019-06', '2019-06-23'))
     assert_equal(1, DateHandler.compare_month('2019-06', '2018-05-24'))
     assert_equal(-1, DateHandler.compare_month('2018-12', '2019-01-25'))
   end

   def test_add_last_day
     assert_equal('2019-01-31', DateHandler.add_last_day('2019-01'))
     assert_equal('2019-02-28', DateHandler.add_last_day('2019-02'))
     assert_equal('2019-09-30', DateHandler.add_last_day('2019-09'))
     assert_equal('2019-10-31', DateHandler.add_last_day('2019-10'))
   end
 end
