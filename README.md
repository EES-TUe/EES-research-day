# EES Research Day website

Website for the annual Research Day of the Electrical Energy Systems (EES) group at TU Eindhoven. Build using Jekyll.

**Live site:** https://ees-tue.github.io/EES-research-day/

Each edition is located at `/<year>/`, e.g. `/2026/`.

## Editing content

All content lives in one YAML file per edition such as `_data/editions/2026.yml`.

## Adding a new edition (e.g. 2027)

1. Copy `_data/editions/2026.yml` to `_data/editions/2027.yml` and update it.
2. Copy the `2026/` folder to `2027/`, then change `edition: "2026"` to `"2027"` in the three files inside it.
3. In `_config.yml`, set `current_edition: "2027"` so the site root redirects to the new edition.
4. In `2026.yml`, set `status: past`. That turns the 2026 page into an archive and hides its registration links.

The edition switcher in the header picks up new years automatically.

## Previewing locally

Using podman:

```sh
podman run --rm -it -v "$PWD":/srv:Z -w /srv -p 4000:4000 docker.io/library/ruby:3.3 \
  sh -c "bundle install && bundle exec jekyll serve --host 0.0.0.0"
```

Then open http://localhost:4000/EES-research-day/.
