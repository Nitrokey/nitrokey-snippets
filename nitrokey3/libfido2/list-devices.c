// Copyright (C) Nitrokey GmbH
// SPDX-License-Identifier: Unlicense

#include <fido.h>
#include <stdio.h>

const size_t DEVICE_COUNT = 10;

static void print_dev_info(const fido_dev_info_t *dev_info) {
  const char *path = fido_dev_info_path(dev_info);
  const int16_t vid = fido_dev_info_vendor(dev_info);
  const int16_t pid = fido_dev_info_product(dev_info);
  const char *manufacturer = fido_dev_info_manufacturer_string(dev_info);
  const char *product = fido_dev_info_product_string(dev_info);
  if (path == NULL || manufacturer == NULL || product == NULL) {
    return;
  }
  printf("- %s: %s %s (%04x:%04x)\n", path, manufacturer, product, vid, pid);
}

int main(int argc, char *argv[]) {
  if (argc != 1) {
    fprintf(stderr, "Usage: %s\n", argv[0]);
    return 1;
  }

  int return_value = 1;

  fido_init(0);

  fido_dev_info_t *dev_infos = fido_dev_info_new(DEVICE_COUNT);
  if (dev_infos == NULL) {
    fprintf(stderr, "fido_dev_info_new failed\n");
    goto err;
  }

  size_t n = 0;
  int result = fido_dev_info_manifest(dev_infos, DEVICE_COUNT, &n);
  if (result != FIDO_OK) {
    fprintf(stderr, "fido_dev_info_manifest failed with error code %d\n",
            result);
    goto err;
  }

  if (n == 0) {
    printf("no FIDO2 device connected\n");
  } else if (n == 1) {
    printf("1 FIDO2 device connected:\n");
  } else if (n == DEVICE_COUNT) {
    printf("at least %lu FIDO2 devices connected:\n", n);
  } else {
    printf("%lu FIDO2 devices connected:\n", n);
  }

  for (size_t i = 0; i < n; i++) {
    const fido_dev_info_t *dev_info = fido_dev_info_ptr(dev_infos, i);
    if (dev_info == NULL) {
      fprintf(stderr, "fido_dev_info_ptr failed\n");
      goto err;
    }
    print_dev_info(dev_info);
  }

  return_value = 0;

err:
  fido_dev_info_free(&dev_infos, DEVICE_COUNT);

  return return_value;
}
