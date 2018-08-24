namespace :deployment do
  TAG = `git rev-parse --short HEAD`.strip

  desc 'Run jobs to deploy the app'
  task :deploy do
    Rake::Task['deployment:check'].execute
    Rake::Task['deployment:build_image'].execute
    Rake::Task['deployment:push_image'].execute
    Rake::Task['deployment:apply'].execute
  end

  desc 'Check the prerequisites'
  task :check do
    puts "\e[36mChecking prerequisites...\e[0m"

    if system("git diff --exit-code > /dev/null 2>&1") && system("git diff --cached --exit-code > /dev/null 2>&1")
      puts "git repository is \e[32mclean\e[0m"
    else
      puts "git has \e[31mchanges\e[0m - commit your work and try again"
      abort "\e[31m!!!\e[0m Your Git working tree is not clean! Commit your work and try again."
    end

    all_ok = true
    %w(docker gcloud kubectl).each do |bin|
      is_present = system "which #{bin} > /dev/null 2>&1"

      if is_present
        puts "#{bin} is \e[32mpresent\e[0m"
      else
        puts "#{bin} is \e[31mmissing\e[0m"
        all_ok = false
      end
    end

    unless all_ok
      abort "\e[31m!!!\e[0m Some components are missing. Please consult the README and install them."
    end

    if system("gcloud config list 2>/dev/null | grep 'project = oxon-infrastructure' > /dev/null")
      puts "GCP project is \e[32mset\e[0m"
    else
      puts "GCP project is \e[31mnot set\e[0m"
      all_ok = false
    end

    unless all_ok
      abort "\e[31m!!!\e[0m Use `gcloud init` and setup/activate the Google Cloud Platform project 'oxon-infrastructure'."
    end

    puts "\e[32mDone!\e[0m"
  end

  desc 'Build and tag Rails image'
  task :build_image do
    puts "\e[36mBuilding and tagging Docker images...\e[0m"
    sh "docker build -t eu.gcr.io/oxon-infrastructure/oxomine:#{TAG} -t eu.gcr.io/oxon-infrastructure/oxomine:latest ."
    puts "\e[32mDone!\e[0m"
  end

  desc 'Push images to Cloud Registry'
  task :push_image do
    puts "\e[36mPushing Docker image to Container Registry...\e[0m"
    sh "docker push eu.gcr.io/oxon-infrastructure/oxomine:#{TAG}"
    sh "docker push eu.gcr.io/oxon-infrastructure/oxomine:latest"
    puts "\e[32mDone!\e[0m"
  end

  desc 'Apply the new configuration to a Kubernetes cluster'
  task :apply do
    puts
    puts "\e[36mApplying the new configuration in the Kubernetes cluster 'oxon-infrastructure'...\e[0m"
    sh "gcloud container clusters get-credentials shared-cluster"
    sh "sed 's/$TAG/#{TAG}/g' #{Rails.root.join('deploy/oxomine.yaml')} | kubectl apply -f -"
    puts "\e[32mDone!\e[0m"
  end
end
