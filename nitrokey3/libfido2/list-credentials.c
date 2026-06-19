// Copyright (C) Nitrokey GmbH
// SPDX-License-Identifier: Unlicense

#include <fido.h>
#include <fido/credman.h>
#include <stdio.h>

const size_t DEVICE_COUNT = 10;

static void print_hex_str(const unsigned char *s, size_t n) {
  for (size_t i = 0; i < n; i++) {
    printf("%x", s[i]);
  }
}

static int list_credentials(fido_dev_t *dev, const char *pin) {
  fido_credman_metadata_t *metadata = NULL;
  fido_credman_rp_t *rp = NULL;
  fido_credman_rk_t *rk = NULL;
  int return_value = 1;

  metadata = fido_credman_metadata_new();
  if (metadata == NULL) {
    fprintf(stderr, "fido_credman_metadata_new failed\n");
    goto err;
  }

  int result = fido_credman_get_dev_metadata(dev, metadata, pin);
  if (result != FIDO_OK) {
    fprintf(stderr, "fido_credman_get_dev_metadata failed with error code %d\n",
            result);
    goto err;
  }

  uint64_t existing = fido_credman_rk_existing(metadata);
  uint64_t remaining = fido_credman_rk_remaining(metadata);
  printf("existing credentials:  %lu\n", existing);
  printf("remaining credentials: %lu\n", remaining);

  rp = fido_credman_rp_new();
  if (rp == NULL) {
    fprintf(stderr, "fido_credman_rp_new failed\n");
    goto err;
  }

  rk = fido_credman_rk_new();
  if (rk == NULL) {
    fprintf(stderr, "fido_credman_rk_new failed\n");
    goto err;
  }

  result = fido_credman_get_dev_rp(dev, rp, pin);
  if (result != FIDO_OK) {
    fprintf(stderr, "fido_credman_get_dev_rp failed with error code %d\n",
            result);
    goto err;
  }

  size_t rp_count = fido_credman_rp_count(rp);
  for (size_t rp_idx = 0; rp_idx < rp_count; rp_idx++) {
    const char *rp_id = fido_credman_rp_id(rp, rp_idx);
    const char *rp_name = fido_credman_rp_name(rp, rp_idx);
    if (rp_id == NULL) {
      continue;
    }
    printf("- %s", rp_id);
    if (rp_name != NULL) {
      printf(" (%s)", rp_name);
    }
    printf("\n");

    result = fido_credman_get_dev_rk(dev, rp_id, rk, pin);
    if (result != FIDO_OK) {
      fprintf(stderr, "fido_credman_get_dev_rk failed with error code %d\n",
              result);
      goto err;
    }

    size_t rk_count = fido_credman_rk_count(rk);
    for (size_t rk_idx = 0; rk_idx < rk_count; rk_idx++) {
      const fido_cred_t *cred = fido_credman_rk(rk, rk_idx);
      if (cred == NULL) {
        fprintf(stderr, "fido_credman_rk failed\n");
        goto err;
      }

      const unsigned char *id_ptr = fido_cred_id_ptr(cred);
      size_t id_len = fido_cred_id_len(cred);
      const unsigned char *user_id_ptr = fido_cred_user_id_ptr(cred);
      size_t user_id_len = fido_cred_user_id_len(cred);
      if (id_ptr == NULL || user_id_ptr == NULL) {
        continue;
      }
      const char *user_name = fido_cred_user_name(cred);
      const char *display_name = fido_cred_display_name(cred);

      printf("  - id: ");
      print_hex_str(id_ptr, id_len);
      printf("\n");
      printf("    user: ");
      if (user_name != NULL && display_name != NULL) {
        printf("%s (%s)", display_name, user_name);
      } else if (display_name != NULL) {
        printf("%s", display_name);
      } else if (user_name != NULL) {
        printf("%s", user_name);
      } else {
        print_hex_str(user_id_ptr, user_id_len);
      }
      printf("\n");
    }
  }

  return_value = 0;

err:
  fido_credman_rk_free(&rk);
  fido_credman_rp_free(&rp);
  fido_credman_metadata_free(&metadata);

  return return_value;
}

int main(int argc, char *argv[]) {
  if (argc != 3) {
    fprintf(stderr, "Usage: %s device pin\n", argv[0]);
    return 1;
  }
  const char *path = argv[1];
  const char *pin = argv[2];

  int return_value = 1;

  fido_init(0);

  fido_dev_t *dev = fido_dev_new();
  if (dev == NULL) {
    fprintf(stderr, "fido_dev_new failed\n");
    goto err;
  }

  int result = fido_dev_open(dev, path);
  if (result != FIDO_OK) {
    fprintf(stderr, "fido_dev_open failed with error code %d\n", result);
    goto err;
  }

  result = list_credentials(dev, pin);
  if (result == 0) {
    return_value = 0;
  }

  fido_dev_close(dev);

err:
  fido_dev_free(&dev);

  return return_value;
}
