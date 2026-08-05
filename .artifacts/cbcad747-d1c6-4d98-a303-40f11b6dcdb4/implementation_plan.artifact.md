# Implementation Plan - Add "Load More" to CategoryBloc

The goal is to implement pagination for category details in the `CategoryBloc`. This will allow the UI to request more items when the user scrolls to the bottom of the list.

## User Review Required

> [!IMPORTANT]
> I will be adding a `hasReachedMax` boolean to the `CategoryState` to track if there are more items to load.
> I will also add `isFetchingMore` to avoid duplicate requests while a "load more" operation is in progress.

## Proposed Changes

### [Category Bloc]

#### [MODIFY] [category_state.dart](file:///Users/macbook/Documents/GitHub/golidoli-app/lib/features/home/bloc/category/category_state.dart)
- Add `hasReachedMax` (bool) to track the end of the list.
- Add `isFetchingMore` (bool) to track the "load more" status.

#### [MODIFY] [category_bloc.dart](file:///Users/macbook/Documents/GitHub/golidoli-app/lib/features/home/bloc/category/category_bloc.dart)
- Update `_DetailCategory` handler to reset `pageNo` to 0, clear existing `categoryDetail`, and reset `hasReachedMax`.
- Implement `_LoadMore` handler:
    - Check if `hasReachedMax` or `isFetchingMore` is true.
    - Set `isFetchingMore` to true.
    - Increment `pageNo`.
    - Fetch data using `_categoryDetailUsecase`.
    - If success:
        - Append new content to the existing `categoryDetail.content`.
        - If the new content length is less than `pageSize`, set `hasReachedMax` to true.
    - Set `isFetchingMore` to false.

## Verification Plan

### Automated Tests
- I'll check if the project has existing tests for `CategoryBloc`. If so, I'll add a test case for "load more".

### Manual Verification
- Since I cannot run the app, I will verify the logic by ensuring:
    - `pageNo` increments correctly.
    - New content is appended to the existing list.
    - `hasReachedMax` is set correctly when no more data is returned.
