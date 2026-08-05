// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryEvent()';
}


}

/// @nodoc
class $CategoryEventCopyWith<$Res>  {
$CategoryEventCopyWith(CategoryEvent _, $Res Function(CategoryEvent) __);
}


/// Adds pattern-matching-related methods to [CategoryEvent].
extension CategoryEventPatterns on CategoryEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AllCategory value)?  allCategory,TResult Function( _DetailCategory value)?  detailCategory,TResult Function( _LoadMore value)?  loadMore,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AllCategory() when allCategory != null:
return allCategory(_that);case _DetailCategory() when detailCategory != null:
return detailCategory(_that);case _LoadMore() when loadMore != null:
return loadMore(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AllCategory value)  allCategory,required TResult Function( _DetailCategory value)  detailCategory,required TResult Function( _LoadMore value)  loadMore,}){
final _that = this;
switch (_that) {
case _AllCategory():
return allCategory(_that);case _DetailCategory():
return detailCategory(_that);case _LoadMore():
return loadMore(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AllCategory value)?  allCategory,TResult? Function( _DetailCategory value)?  detailCategory,TResult? Function( _LoadMore value)?  loadMore,}){
final _that = this;
switch (_that) {
case _AllCategory() when allCategory != null:
return allCategory(_that);case _DetailCategory() when detailCategory != null:
return detailCategory(_that);case _LoadMore() when loadMore != null:
return loadMore(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  allCategory,TResult Function( String id)?  detailCategory,TResult Function( String id)?  loadMore,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AllCategory() when allCategory != null:
return allCategory();case _DetailCategory() when detailCategory != null:
return detailCategory(_that.id);case _LoadMore() when loadMore != null:
return loadMore(_that.id);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  allCategory,required TResult Function( String id)  detailCategory,required TResult Function( String id)  loadMore,}) {final _that = this;
switch (_that) {
case _AllCategory():
return allCategory();case _DetailCategory():
return detailCategory(_that.id);case _LoadMore():
return loadMore(_that.id);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  allCategory,TResult? Function( String id)?  detailCategory,TResult? Function( String id)?  loadMore,}) {final _that = this;
switch (_that) {
case _AllCategory() when allCategory != null:
return allCategory();case _DetailCategory() when detailCategory != null:
return detailCategory(_that.id);case _LoadMore() when loadMore != null:
return loadMore(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _AllCategory implements CategoryEvent {
  const _AllCategory();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllCategory);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryEvent.allCategory()';
}


}




/// @nodoc


class _DetailCategory implements CategoryEvent {
  const _DetailCategory({required this.id});
  

 final  String id;

/// Create a copy of CategoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailCategoryCopyWith<_DetailCategory> get copyWith => __$DetailCategoryCopyWithImpl<_DetailCategory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetailCategory&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'CategoryEvent.detailCategory(id: $id)';
}


}

/// @nodoc
abstract mixin class _$DetailCategoryCopyWith<$Res> implements $CategoryEventCopyWith<$Res> {
  factory _$DetailCategoryCopyWith(_DetailCategory value, $Res Function(_DetailCategory) _then) = __$DetailCategoryCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class __$DetailCategoryCopyWithImpl<$Res>
    implements _$DetailCategoryCopyWith<$Res> {
  __$DetailCategoryCopyWithImpl(this._self, this._then);

  final _DetailCategory _self;
  final $Res Function(_DetailCategory) _then;

/// Create a copy of CategoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_DetailCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _LoadMore implements CategoryEvent {
  const _LoadMore({required this.id});
  

 final  String id;

/// Create a copy of CategoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadMoreCopyWith<_LoadMore> get copyWith => __$LoadMoreCopyWithImpl<_LoadMore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadMore&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'CategoryEvent.loadMore(id: $id)';
}


}

/// @nodoc
abstract mixin class _$LoadMoreCopyWith<$Res> implements $CategoryEventCopyWith<$Res> {
  factory _$LoadMoreCopyWith(_LoadMore value, $Res Function(_LoadMore) _then) = __$LoadMoreCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class __$LoadMoreCopyWithImpl<$Res>
    implements _$LoadMoreCopyWith<$Res> {
  __$LoadMoreCopyWithImpl(this._self, this._then);

  final _LoadMore _self;
  final $Res Function(_LoadMore) _then;

/// Create a copy of CategoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_LoadMore(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$CategoryState {

 CategoriesResponse? get allCategories; Status get categoryStatus; Status get detailCategoryStatus; CategoryContentResponse? get categoryDetail; int get pageNo; int get pageSize; bool get hasMore;
/// Create a copy of CategoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryStateCopyWith<CategoryState> get copyWith => _$CategoryStateCopyWithImpl<CategoryState>(this as CategoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryState&&(identical(other.allCategories, allCategories) || other.allCategories == allCategories)&&(identical(other.categoryStatus, categoryStatus) || other.categoryStatus == categoryStatus)&&(identical(other.detailCategoryStatus, detailCategoryStatus) || other.detailCategoryStatus == detailCategoryStatus)&&(identical(other.categoryDetail, categoryDetail) || other.categoryDetail == categoryDetail)&&(identical(other.pageNo, pageNo) || other.pageNo == pageNo)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,allCategories,categoryStatus,detailCategoryStatus,categoryDetail,pageNo,pageSize,hasMore);

@override
String toString() {
  return 'CategoryState(allCategories: $allCategories, categoryStatus: $categoryStatus, detailCategoryStatus: $detailCategoryStatus, categoryDetail: $categoryDetail, pageNo: $pageNo, pageSize: $pageSize, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $CategoryStateCopyWith<$Res>  {
  factory $CategoryStateCopyWith(CategoryState value, $Res Function(CategoryState) _then) = _$CategoryStateCopyWithImpl;
@useResult
$Res call({
 CategoriesResponse? allCategories, Status categoryStatus, Status detailCategoryStatus, CategoryContentResponse? categoryDetail, int pageNo, int pageSize, bool hasMore
});




}
/// @nodoc
class _$CategoryStateCopyWithImpl<$Res>
    implements $CategoryStateCopyWith<$Res> {
  _$CategoryStateCopyWithImpl(this._self, this._then);

  final CategoryState _self;
  final $Res Function(CategoryState) _then;

/// Create a copy of CategoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allCategories = freezed,Object? categoryStatus = null,Object? detailCategoryStatus = null,Object? categoryDetail = freezed,Object? pageNo = null,Object? pageSize = null,Object? hasMore = null,}) {
  return _then(_self.copyWith(
allCategories: freezed == allCategories ? _self.allCategories : allCategories // ignore: cast_nullable_to_non_nullable
as CategoriesResponse?,categoryStatus: null == categoryStatus ? _self.categoryStatus : categoryStatus // ignore: cast_nullable_to_non_nullable
as Status,detailCategoryStatus: null == detailCategoryStatus ? _self.detailCategoryStatus : detailCategoryStatus // ignore: cast_nullable_to_non_nullable
as Status,categoryDetail: freezed == categoryDetail ? _self.categoryDetail : categoryDetail // ignore: cast_nullable_to_non_nullable
as CategoryContentResponse?,pageNo: null == pageNo ? _self.pageNo : pageNo // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryState].
extension CategoryStatePatterns on CategoryState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryState value)  $default,){
final _that = this;
switch (_that) {
case _CategoryState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryState value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CategoriesResponse? allCategories,  Status categoryStatus,  Status detailCategoryStatus,  CategoryContentResponse? categoryDetail,  int pageNo,  int pageSize,  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryState() when $default != null:
return $default(_that.allCategories,_that.categoryStatus,_that.detailCategoryStatus,_that.categoryDetail,_that.pageNo,_that.pageSize,_that.hasMore);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CategoriesResponse? allCategories,  Status categoryStatus,  Status detailCategoryStatus,  CategoryContentResponse? categoryDetail,  int pageNo,  int pageSize,  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _CategoryState():
return $default(_that.allCategories,_that.categoryStatus,_that.detailCategoryStatus,_that.categoryDetail,_that.pageNo,_that.pageSize,_that.hasMore);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CategoriesResponse? allCategories,  Status categoryStatus,  Status detailCategoryStatus,  CategoryContentResponse? categoryDetail,  int pageNo,  int pageSize,  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _CategoryState() when $default != null:
return $default(_that.allCategories,_that.categoryStatus,_that.detailCategoryStatus,_that.categoryDetail,_that.pageNo,_that.pageSize,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc


class _CategoryState implements CategoryState {
  const _CategoryState({this.allCategories = null, this.categoryStatus = Status.init, this.detailCategoryStatus = Status.init, this.categoryDetail = null, this.pageNo = 0, this.pageSize = 10, this.hasMore = false});
  

@override@JsonKey() final  CategoriesResponse? allCategories;
@override@JsonKey() final  Status categoryStatus;
@override@JsonKey() final  Status detailCategoryStatus;
@override@JsonKey() final  CategoryContentResponse? categoryDetail;
@override@JsonKey() final  int pageNo;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  bool hasMore;

/// Create a copy of CategoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryStateCopyWith<_CategoryState> get copyWith => __$CategoryStateCopyWithImpl<_CategoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryState&&(identical(other.allCategories, allCategories) || other.allCategories == allCategories)&&(identical(other.categoryStatus, categoryStatus) || other.categoryStatus == categoryStatus)&&(identical(other.detailCategoryStatus, detailCategoryStatus) || other.detailCategoryStatus == detailCategoryStatus)&&(identical(other.categoryDetail, categoryDetail) || other.categoryDetail == categoryDetail)&&(identical(other.pageNo, pageNo) || other.pageNo == pageNo)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,allCategories,categoryStatus,detailCategoryStatus,categoryDetail,pageNo,pageSize,hasMore);

@override
String toString() {
  return 'CategoryState(allCategories: $allCategories, categoryStatus: $categoryStatus, detailCategoryStatus: $detailCategoryStatus, categoryDetail: $categoryDetail, pageNo: $pageNo, pageSize: $pageSize, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$CategoryStateCopyWith<$Res> implements $CategoryStateCopyWith<$Res> {
  factory _$CategoryStateCopyWith(_CategoryState value, $Res Function(_CategoryState) _then) = __$CategoryStateCopyWithImpl;
@override @useResult
$Res call({
 CategoriesResponse? allCategories, Status categoryStatus, Status detailCategoryStatus, CategoryContentResponse? categoryDetail, int pageNo, int pageSize, bool hasMore
});




}
/// @nodoc
class __$CategoryStateCopyWithImpl<$Res>
    implements _$CategoryStateCopyWith<$Res> {
  __$CategoryStateCopyWithImpl(this._self, this._then);

  final _CategoryState _self;
  final $Res Function(_CategoryState) _then;

/// Create a copy of CategoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allCategories = freezed,Object? categoryStatus = null,Object? detailCategoryStatus = null,Object? categoryDetail = freezed,Object? pageNo = null,Object? pageSize = null,Object? hasMore = null,}) {
  return _then(_CategoryState(
allCategories: freezed == allCategories ? _self.allCategories : allCategories // ignore: cast_nullable_to_non_nullable
as CategoriesResponse?,categoryStatus: null == categoryStatus ? _self.categoryStatus : categoryStatus // ignore: cast_nullable_to_non_nullable
as Status,detailCategoryStatus: null == detailCategoryStatus ? _self.detailCategoryStatus : detailCategoryStatus // ignore: cast_nullable_to_non_nullable
as Status,categoryDetail: freezed == categoryDetail ? _self.categoryDetail : categoryDetail // ignore: cast_nullable_to_non_nullable
as CategoryContentResponse?,pageNo: null == pageNo ? _self.pageNo : pageNo // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
