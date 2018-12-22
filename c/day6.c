#include <stdio.h>
#include <stdlib.h>

// linked list
typedef struct list_t list_t;
struct list_t {
  int id;
  int x;
  int y;
  list_t *next;
};

// print a linked list of list_t
void print_list(list_t *list) {
  list_t *current = list;
  while (current) {
    printf("%i x: %i, y: %i\n", current->id, current->x, current->y);
    current = current->next;
  }
}

// get the x and y extent of a list_t
void list_extent(list_t *list, int *x_from, int *x_to, int *y_from, int *y_to) {
  list_t *current = list;
  while (current) {                       
    if (current->x > *x_to) *x_to = current->x;
    if (current->x < *x_from) *x_from = current->x;
    if (current->y > *y_to) *y_to = current->y;
    if (current->y < *y_from) *y_from = current->y;
    current = current->next;
  }
}

// find the nearest point to x, y in a list_t
list_t *find_nearest_point(int x, int y, list_t *list) {
  list_t *nearest = list;
  list_t *current = list;
  int current_distance = 9999;

  while (current) {                
    int distance = abs(x - current->x) + abs(y - current->y);
    if (distance < current_distance) {
      current_distance = distance;
      nearest = current;
    }
    current = current->next;
  }

  return nearest;
}

// returns 1 if the total distance to every point in a list_t to x, y
// is < max_dist
int total_dist_less_than(int x, int y, int max_dist, list_t *item) {
  int total_dist = 0;
  while (item) {
    int dist = abs(x - item->x) + abs(y - item->y);
    total_dist += dist;
    if (total_dist >= max_dist)
      return 0;
    item = item->next;
  }
  return 1;
}

int main() {
  list_t *head = NULL;
  list_t *current = NULL;

  int file_x;
  int file_y;
  int current_id = 0;

  // read input from stdin
  while (scanf("%i, %i\n", &file_x, &file_y) != EOF) {
    list_t *item = malloc(sizeof(list_t));
    item->id = current_id++;
    item->x = file_x;
    item->y = file_y;

    if (head == NULL) {
      head = item;
      current = item;
      continue;
    }
    current->next = item;
    current = item;
  }

  // print_list(head);

  int x_from = 9999;
  int x_to = 0;
  int y_from = 9999;
  int y_to = 0;

  list_extent(head, &x_from, &x_to, &y_from, &y_to);

  int counts[100] = { 0 };
  int part2_area = 0;

  for (int y = y_from; y <= y_to; y++) {
    for (int x = x_from; x <= x_to; x++) {
      if (total_dist_less_than(x, y, 10000, head)) {
        part2_area++;
      }

      list_t *nearest = find_nearest_point(x, y, head);
      if (x == x_from || x == x_to || y == y_from || y == y_to) {
        // infinite, mark with -1
        counts[nearest->id] = -1;
      } else if (counts[nearest->id] != -1) {
        counts[nearest->id]++;
      }
    }
  }

  int max = 0;
  for (int i = 0; i < current_id; i++) {
    if (counts[i] > max) max = counts[i];
  }

  printf("part1: %i\n", max);
  printf("part2: %i\n", part2_area);

  return 0;
}
