# EES Research Day website

Website for the annual Research Day of the Electrical Energy Systems (EES) group at TU Eindhoven.
It is a [Jekyll](https://jekyllrb.com/) site that GitHub Pages builds automatically. There's no build step to run yourself.

**Live site:** https://ees-tue.github.io/EES-research-day-2026/

## Editing content

All content lives in one YAML file per edition, so you don't need to touch HTML:

| File | What it holds |
| --- | --- |
| `_data/editions/2026.yml` | Date, intro text, registration steps, programme, speakers, presentations, venue |
| `_data/editions/2025.yml` | The 2025 edition, kept as an archive |

Edit the file on GitHub (pencil icon) and commit. The site updates within a minute or two.

Tips:
- **Always quote times** (`"09:00"`). YAML reads unquoted `09:00` as a number.
- **Quote any text containing a comma or colon** inside `{ ... }` entries.
- Add `tbc: true` to a programme slot or speaker to show a **TBC** badge.
- Leave a field out, or empty, to hide it. A section with no data isn't shown.
- Speaker photos go in `assets/img/<year>/`, as square images of about 400×400 px. Reference them with `photo: /assets/img/<year>/name.jpg`.
- `programme[].ref` links a slot to a speaker card (`speaker-<id>`), a session (`session-1`) or `alumni`.

### Registration
Registration goes through the **EES Employee** environment in Microsoft Teams. The `registration:` block in the edition file controls the `/2026/register/` page:

```yaml
registration:
  deadline: 2026-12-04        # optional
  teams_link: https://teams.microsoft.com/l/...   # optional; shows an "Open in Microsoft Teams" button
  steps:
    - Open **Microsoft Teams** ...
  notes: Anything else people should know (optional)
```

## Adding a new edition (e.g. 2027)

1. Copy `_data/editions/2026.yml` to `_data/editions/2027.yml` and update it.
2. Copy the `2026/` folder to `2027/`, then change `edition: "2026"` to `"2027"` in the three files inside it.
3. In `_config.yml`, set `current_edition: "2027"` so the site root shows the new edition.
4. In `2026.yml`, set `status: past`. That turns the 2026 page into an archive and hides its registration links. You can then delete `2026/register/` and `2026/event.ics`.

The edition switcher in the header picks up new years automatically.

## Previewing locally

You don't need Ruby installed; a container works:

```sh
podman run --rm -it -v "$PWD":/srv:Z -w /srv -p 4000:4000 docker.io/library/ruby:3.3 \
  sh -c "bundle install && bundle exec jekyll serve --host 0.0.0.0"
```

Then open http://localhost:4000/EES-research-day-2026/. `docker` works the same way.

## Structure

```
_config.yml              site settings, current_edition, baseurl (= repository name)
_data/editions/*.yml     content, one file per edition
_layouts/                default (shell + header), edition (main page), register
_includes/               page sections (hero, programme, speakers, pitches, ...)
<year>/                  page stubs per edition: index.html, register/, event.ics
assets/                  CSS, images, favicon
```

If the repository is renamed, update `baseurl` and `repository` in `_config.yml`.
