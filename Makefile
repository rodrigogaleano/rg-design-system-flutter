# Pinned Flutter image so goldens are generated in the same environment the CI
# compares them against. Keep this tag in sync with .github/workflows/ci.yml.
FLUTTER_IMAGE := ghcr.io/cirruslabs/flutter:3.44.0

.PHONY: goldens
goldens: ## Regenerate the golden files inside the same Linux image the CI uses
	docker run --rm -v "$(CURDIR)":/app -w /app $(FLUTTER_IMAGE) \
		bash -lc "git config --global --add safe.directory /app && \
		          flutter pub get && \
		          flutter test --update-goldens --tags golden"
