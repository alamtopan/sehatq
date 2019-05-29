namespace :cron_job do
  desc "JOB TO DELETE FILES EVERY 2 HOURS"
  task run_delete_files: :environment do
    upload_files = UploadFile.destroy_all
  end
end
      