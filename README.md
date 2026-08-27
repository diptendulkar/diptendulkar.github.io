# diptendulkar.github.io

The public website for my Android apps: one page per app, and the privacy policy each app links to.

Live at <https://diptendulkar.github.io/>.

## Why this repository holds them

Google Play requires a privacy policy URL that anyone can open without signing in. The app source
repositories are private, and GitHub Pages will not publish from a private repository on the free
plan, so the policies live here instead. Keeping every app in one place means one site to maintain
and URLs that stay valid for as long as the apps are listed.

## Layout

```
/                          this page, listing the apps
/style.css                 shared styling; each app sets its accent via a class on <html>
/app-ads.txt               AdMob verification, which must stay at the domain root
/<app>/                    that app's overview page
/<app>/privacy-policy/     the URL given to the Play Console and linked from inside the app
```

| App | Overview | Privacy policy |
| --- | --- | --- |
| SkillZora | [/skillzora/](https://diptendulkar.github.io/skillzora/) | [/skillzora/privacy-policy/](https://diptendulkar.github.io/skillzora/privacy-policy/) |
| DocScan India | [/docscan/](https://diptendulkar.github.io/docscan/) | [/docscan/privacy-policy/](https://diptendulkar.github.io/docscan/privacy-policy/) |
| Dilse | [/dilse/](https://diptendulkar.github.io/dilse/) | [/dilse/privacy-policy/](https://diptendulkar.github.io/dilse/privacy-policy/) |
| Text Repeater | [/textrepeater/](https://diptendulkar.github.io/textrepeater/) | [/textrepeater/privacy-policy/](https://diptendulkar.github.io/textrepeater/privacy-policy/) |
| Daily Motivational | [/motivational/](https://diptendulkar.github.io/motivational/) | [/motivational/privacy-policy/](https://diptendulkar.github.io/motivational/privacy-policy/) |
| Made In India | [/madeinindia/](https://diptendulkar.github.io/madeinindia/) | [/madeinindia/privacy-policy/](https://diptendulkar.github.io/madeinindia/privacy-policy/) |

## Adding an app

Copy the `docscan` folder, rewrite the two pages, add an accent block for it in `style.css` if you
want a different colour, and add a row to the list on the front page and to the table above.

Write the policy to match what the app actually does. Apps that show ads or use analytics collect an
advertising identifier and must say so; do not copy DocScan's "we collect nothing" wording into an
app where it is not true.

## How it is built

It is not built. These are hand-written static files, and `.nojekyll` tells GitHub Pages to serve
them as they are rather than running them through Jekyll, so there is no build step to fail and
nothing to install to preview a change — just open `index.html` in a browser.

Changes are usually live within a minute of pushing to `main`. Check a new policy URL in a private
window before pasting it into the Play Console.
