# Pipeline Runner

## How to execute the pipeline runner
You have to execute it inside the project folder where the `.gitlab-ci.yml` is stored, so type:
```
$ cd <YOUR PROJECT>
$ ruby <PIPELINE RUNNER PATH>/pipeline-runner
```

## For developers

### Add a new gem
In `Gemfile`, add your gem in this way:
```
gem "<GEM NAME>"
```
then, execute:
```
bundle install
```
