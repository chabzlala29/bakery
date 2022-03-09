# Bakery

1. Run `bundle install` to install packages, make sure to use 3.1.0 Ruby version as stated in `.ruby_version` file.
2. All basic scenarios and tests are located in `spec/lib/bakery_spec.rb`
3. Run `bin/console` if you want to test the functionality yourself:
  ```ruby
    bakery = Bakery.new
    bakery.process_packaging(10, "VS5")
    
    => {:total_cost=>17.98, :sorted_packages=>[{:number_of_boxes=>2, :price_per_box=>8.99}]}
  ```
4. Satisfied on my work? You can hire me now and contact me at `cpobre.peg@gmail.com`. Looking forward to work with you! :)
