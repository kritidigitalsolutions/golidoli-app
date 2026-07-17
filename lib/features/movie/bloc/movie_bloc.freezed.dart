// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MovieEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MovieEvent()';
}


}

/// @nodoc
class $MovieEventCopyWith<$Res>  {
$MovieEventCopyWith(MovieEvent _, $Res Function(MovieEvent) __);
}


/// Adds pattern-matching-related methods to [MovieEvent].
extension MovieEventPatterns on MovieEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AllMovies value)?  allMovies,TResult Function( _MovieDetail value)?  movieDetail,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AllMovies() when allMovies != null:
return allMovies(_that);case _MovieDetail() when movieDetail != null:
return movieDetail(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AllMovies value)  allMovies,required TResult Function( _MovieDetail value)  movieDetail,}){
final _that = this;
switch (_that) {
case _AllMovies():
return allMovies(_that);case _MovieDetail():
return movieDetail(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AllMovies value)?  allMovies,TResult? Function( _MovieDetail value)?  movieDetail,}){
final _that = this;
switch (_that) {
case _AllMovies() when allMovies != null:
return allMovies(_that);case _MovieDetail() when movieDetail != null:
return movieDetail(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  allMovies,TResult Function( String value)?  movieDetail,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AllMovies() when allMovies != null:
return allMovies();case _MovieDetail() when movieDetail != null:
return movieDetail(_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  allMovies,required TResult Function( String value)  movieDetail,}) {final _that = this;
switch (_that) {
case _AllMovies():
return allMovies();case _MovieDetail():
return movieDetail(_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  allMovies,TResult? Function( String value)?  movieDetail,}) {final _that = this;
switch (_that) {
case _AllMovies() when allMovies != null:
return allMovies();case _MovieDetail() when movieDetail != null:
return movieDetail(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _AllMovies implements MovieEvent {
  const _AllMovies();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllMovies);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MovieEvent.allMovies()';
}


}




/// @nodoc


class _MovieDetail implements MovieEvent {
  const _MovieDetail({required this.value});
  

 final  String value;

/// Create a copy of MovieEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieDetailCopyWith<_MovieDetail> get copyWith => __$MovieDetailCopyWithImpl<_MovieDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieDetail&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'MovieEvent.movieDetail(value: $value)';
}


}

/// @nodoc
abstract mixin class _$MovieDetailCopyWith<$Res> implements $MovieEventCopyWith<$Res> {
  factory _$MovieDetailCopyWith(_MovieDetail value, $Res Function(_MovieDetail) _then) = __$MovieDetailCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class __$MovieDetailCopyWithImpl<$Res>
    implements _$MovieDetailCopyWith<$Res> {
  __$MovieDetailCopyWithImpl(this._self, this._then);

  final _MovieDetail _self;
  final $Res Function(_MovieDetail) _then;

/// Create a copy of MovieEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_MovieDetail(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$MovieState {

 List<MovieModel> get allMovies; MovieModel? get movieDetail; Status get allMoviesStatus; Status get movieDetailStatus;
/// Create a copy of MovieState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieStateCopyWith<MovieState> get copyWith => _$MovieStateCopyWithImpl<MovieState>(this as MovieState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieState&&const DeepCollectionEquality().equals(other.allMovies, allMovies)&&(identical(other.movieDetail, movieDetail) || other.movieDetail == movieDetail)&&(identical(other.allMoviesStatus, allMoviesStatus) || other.allMoviesStatus == allMoviesStatus)&&(identical(other.movieDetailStatus, movieDetailStatus) || other.movieDetailStatus == movieDetailStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(allMovies),movieDetail,allMoviesStatus,movieDetailStatus);

@override
String toString() {
  return 'MovieState(allMovies: $allMovies, movieDetail: $movieDetail, allMoviesStatus: $allMoviesStatus, movieDetailStatus: $movieDetailStatus)';
}


}

/// @nodoc
abstract mixin class $MovieStateCopyWith<$Res>  {
  factory $MovieStateCopyWith(MovieState value, $Res Function(MovieState) _then) = _$MovieStateCopyWithImpl;
@useResult
$Res call({
 List<MovieModel> allMovies, MovieModel? movieDetail, Status allMoviesStatus, Status movieDetailStatus
});




}
/// @nodoc
class _$MovieStateCopyWithImpl<$Res>
    implements $MovieStateCopyWith<$Res> {
  _$MovieStateCopyWithImpl(this._self, this._then);

  final MovieState _self;
  final $Res Function(MovieState) _then;

/// Create a copy of MovieState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allMovies = null,Object? movieDetail = freezed,Object? allMoviesStatus = null,Object? movieDetailStatus = null,}) {
  return _then(_self.copyWith(
allMovies: null == allMovies ? _self.allMovies : allMovies // ignore: cast_nullable_to_non_nullable
as List<MovieModel>,movieDetail: freezed == movieDetail ? _self.movieDetail : movieDetail // ignore: cast_nullable_to_non_nullable
as MovieModel?,allMoviesStatus: null == allMoviesStatus ? _self.allMoviesStatus : allMoviesStatus // ignore: cast_nullable_to_non_nullable
as Status,movieDetailStatus: null == movieDetailStatus ? _self.movieDetailStatus : movieDetailStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieState].
extension MovieStatePatterns on MovieState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieState value)  $default,){
final _that = this;
switch (_that) {
case _MovieState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieState value)?  $default,){
final _that = this;
switch (_that) {
case _MovieState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MovieModel> allMovies,  MovieModel? movieDetail,  Status allMoviesStatus,  Status movieDetailStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieState() when $default != null:
return $default(_that.allMovies,_that.movieDetail,_that.allMoviesStatus,_that.movieDetailStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MovieModel> allMovies,  MovieModel? movieDetail,  Status allMoviesStatus,  Status movieDetailStatus)  $default,) {final _that = this;
switch (_that) {
case _MovieState():
return $default(_that.allMovies,_that.movieDetail,_that.allMoviesStatus,_that.movieDetailStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MovieModel> allMovies,  MovieModel? movieDetail,  Status allMoviesStatus,  Status movieDetailStatus)?  $default,) {final _that = this;
switch (_that) {
case _MovieState() when $default != null:
return $default(_that.allMovies,_that.movieDetail,_that.allMoviesStatus,_that.movieDetailStatus);case _:
  return null;

}
}

}

/// @nodoc


class _MovieState implements MovieState {
  const _MovieState({final  List<MovieModel> allMovies = const [], this.movieDetail = null, this.allMoviesStatus = Status.init, this.movieDetailStatus = Status.init}): _allMovies = allMovies;
  

 final  List<MovieModel> _allMovies;
@override@JsonKey() List<MovieModel> get allMovies {
  if (_allMovies is EqualUnmodifiableListView) return _allMovies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allMovies);
}

@override@JsonKey() final  MovieModel? movieDetail;
@override@JsonKey() final  Status allMoviesStatus;
@override@JsonKey() final  Status movieDetailStatus;

/// Create a copy of MovieState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieStateCopyWith<_MovieState> get copyWith => __$MovieStateCopyWithImpl<_MovieState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieState&&const DeepCollectionEquality().equals(other._allMovies, _allMovies)&&(identical(other.movieDetail, movieDetail) || other.movieDetail == movieDetail)&&(identical(other.allMoviesStatus, allMoviesStatus) || other.allMoviesStatus == allMoviesStatus)&&(identical(other.movieDetailStatus, movieDetailStatus) || other.movieDetailStatus == movieDetailStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_allMovies),movieDetail,allMoviesStatus,movieDetailStatus);

@override
String toString() {
  return 'MovieState(allMovies: $allMovies, movieDetail: $movieDetail, allMoviesStatus: $allMoviesStatus, movieDetailStatus: $movieDetailStatus)';
}


}

/// @nodoc
abstract mixin class _$MovieStateCopyWith<$Res> implements $MovieStateCopyWith<$Res> {
  factory _$MovieStateCopyWith(_MovieState value, $Res Function(_MovieState) _then) = __$MovieStateCopyWithImpl;
@override @useResult
$Res call({
 List<MovieModel> allMovies, MovieModel? movieDetail, Status allMoviesStatus, Status movieDetailStatus
});




}
/// @nodoc
class __$MovieStateCopyWithImpl<$Res>
    implements _$MovieStateCopyWith<$Res> {
  __$MovieStateCopyWithImpl(this._self, this._then);

  final _MovieState _self;
  final $Res Function(_MovieState) _then;

/// Create a copy of MovieState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allMovies = null,Object? movieDetail = freezed,Object? allMoviesStatus = null,Object? movieDetailStatus = null,}) {
  return _then(_MovieState(
allMovies: null == allMovies ? _self._allMovies : allMovies // ignore: cast_nullable_to_non_nullable
as List<MovieModel>,movieDetail: freezed == movieDetail ? _self.movieDetail : movieDetail // ignore: cast_nullable_to_non_nullable
as MovieModel?,allMoviesStatus: null == allMoviesStatus ? _self.allMoviesStatus : allMoviesStatus // ignore: cast_nullable_to_non_nullable
as Status,movieDetailStatus: null == movieDetailStatus ? _self.movieDetailStatus : movieDetailStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}


}

// dart format on
