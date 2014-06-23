namespace :db do
  desc "import data from files to database"
  task :import, [:filename, :advertiser_id] => :environment do |t, args|
    file = File.open(args[:filename])
    file.each_with_index do |line, index|
      current = []
      if index != 0
        reg_exp = /(\D*)(\d{1,2}\/\d{1,2}\/\d{4})(\s*)(\d{1,2}\/\d{1,2}\/\d{4}|\s)(\D*)(\d*)(\s*)(\d*)/
        attrs = line.split(reg_exp)
        attrs.each do |a|
          unless a.match(/\A\s*\z/)
            current << a
          end
        end
        d = Deal.new
        d.advertiser_id = args[:advertiser_id].to_i
        d.proposition = current[0]
        d.start_at = DateTime.parse(current[1])
        begin
          endAt = Date.parse(current[2])
          d.end_at = endAt
          d.description = current[3]
          d.price = current[4]
          d.value = current[5]
        rescue ArgumentError
          d.end_at = nil
          d.description = current[2]
          d.price = current[3]
          d.value = current[4]
        end
        if d.valid?
          res = d.save!
          p "saved deal with id = #{d.id}"
        else
          p "invalid deal"
        end
      end
    end
  end
end