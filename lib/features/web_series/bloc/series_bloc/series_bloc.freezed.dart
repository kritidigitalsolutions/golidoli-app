// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'series_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SeriesEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeriesEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SeriesEvent()';
}


}

/// @nodoc
class $SeriesEventCopyWith<$Res>  {
$SeriesEventCopyWith(SeriesEvent _, $Res Function(SeriesEvent) __);
}


/// Adds pattern-matching-related methods to [SeriesEvent].
extension SeriesEventPatterns on SeriesEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AllSeries value)?  allSeries,TResult Function( _SeriesDetail value)?  seriesDetail,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AllSeries() when allSeries != null:
return allSeries(_that);case _SeriesDetail() when seriesDetail != null:
return seriesDetail(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AllSeries value)  allSeries,required TResult Function( _SeriesDetail value)  seriesDetail,}){
final _that = this;
switch (_that) {
case _AllSeries():
return allSeries(_that);case _SeriesDetail():
return seriesDetail(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AllSeries value)?  allSeries,TResult? Function( _SeriesDetail value)?  seriesDetail,}){
final _that = this;
switch (_that) {
case _AllSeries() when allSeries != null:
return allSeries(_that);case _SeriesDetail() when seriesDetail != null:
return seriesDetail(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  allSeries,TResult Function( String id)?  seriesDetail,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AllSeries() when allSeries != null:
return allSeries();case _SeriesDetail() when seriesDetail != null:
return seriesDetail(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  allSeries,required TResult Function( String id)  seriesDetail,}) {final _that = this;
switch (_that) {
case _AllSeries():
return allSeries();case _SeriesDetail():
return seriesDetail(_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  allSeries,TResult? Function( String id)?  seriesDetail,}) {final _that = this;
switch (_that) {
case _AllSeries() when allSeries != null:
return allSeries();case _SeriesDetail() when seriesDetail != null:
return seriesDetail(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _AllSeries implements SeriesEvent {
  const _AllSeries();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllSeries);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SeriesEvent.allSeries()';
}


}




/// @nodoc


class _SeriesDetail implements SeriesEvent {
  const _SeriesDetail({required this.id});
  

 final  String id;

/// Create a copy of SeriesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeriesDetailCopyWith<_SeriesDetail> get copyWith => __$SeriesDetailCopyWithImpl<_SeriesDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeriesDetail&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'SeriesEvent.seriesDetail(id: $id)';
}


}

/// @nodoc
abstract mixin class _$SeriesDetailCopyWith<$Res> implements $SeriesEventCopyWith<$Res> {
  factory _$SeriesDetailCopyWith(_SeriesDetail value, $Res Function(_SeriesDetail) _then) = __$SeriesDetailCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class __$SeriesDetailCopyWithImpl<$Res>
    implements _$SeriesDetailCopyWith<$Res> {
  __$SeriesDetailCopyWithImpl(this._self, this._then);

  final _SeriesDetail _self;
  final $Res Function(_SeriesDetail) _then;

/// Create a copy of SeriesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_SeriesDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SeriesState {

 SeriesResponse? get allSeries; Series? get seriesDetail; Status get allSeriesStatus; Status get seriesDetailStatus;
/// Create a copy of SeriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeriesStateCopyWith<SeriesState> get copyWith => _$SeriesStateCopyWithImpl<SeriesState>(this as SeriesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeriesState&&(identical(other.allSeries, allSeries) || other.allSeries == allSeries)&&(identical(other.seriesDetail, seriesDetail) || other.seriesDetail == seriesDetail)&&(identical(other.allSeriesStatus, allSeriesStatus) || other.allSeriesStatus == allSeriesStatus)&&(identical(other.seriesDetailStatus, seriesDetailStatus) || other.seriesDetailStatus == seriesDetailStatus));
}


@override
int get hashCode => Object.hash(runtimeType,allSeries,seriesDetail,allSeriesStatus,seriesDetailStatus);

@override
String toString() {
  return 'SeriesState(allSeries: $allSeries, seriesDetail: $seriesDetail, allSeriesStatus: $allSeriesStatus, seriesDetailStatus: $seriesDetailStatus)';
}


}

/// @nodoc
abstract mixin class $SeriesStateCopyWith<$Res>  {
  factory $SeriesStateCopyWith(SeriesState value, $Res Function(SeriesState) _then) = _$SeriesStateCopyWithImpl;
@useResult
$Res call({
 SeriesResponse? allSeries, Series? seriesDetail, Status allSeriesStatus, Status seriesDetailStatus
});




}
/// @nodoc
class _$SeriesStateCopyWithImpl<$Res>
    implements $SeriesStateCopyWith<$Res> {
  _$SeriesStateCopyWithImpl(this._self, this._then);

  final SeriesState _self;
  final $Res Function(SeriesState) _then;

/// Create a copy of SeriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allSeries = freezed,Object? seriesDetail = freezed,Object? allSeriesStatus = null,Object? seriesDetailStatus = null,}) {
  return _then(_self.copyWith(
allSeries: freezed == allSeries ? _self.allSeries : allSeries // ignore: cast_nullable_to_non_nullable
as SeriesResponse?,seriesDetail: freezed == seriesDetail ? _self.seriesDetail : seriesDetail // ignore: cast_nullable_to_non_nullable
as Series?,allSeriesStatus: null == allSeriesStatus ? _self.allSeriesStatus : allSeriesStatus // ignore: cast_nullable_to_non_nullable
as Status,seriesDetailStatus: null == seriesDetailStatus ? _self.seriesDetailStatus : seriesDetailStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}

}


/// Adds pattern-matching-related methods to [SeriesState].
extension SeriesStatePatterns on SeriesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeriesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeriesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeriesState value)  $default,){
final _that = this;
switch (_that) {
case _SeriesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeriesState value)?  $default,){
final _that = this;
switch (_that) {
case _SeriesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SeriesResponse? allSeries,  Series? seriesDetail,  Status allSeriesStatus,  Status seriesDetailStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeriesState() when $default != null:
return $default(_that.allSeries,_that.seriesDetail,_that.allSeriesStatus,_that.seriesDetailStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SeriesResponse? allSeries,  Series? seriesDetail,  Status allSeriesStatus,  Status seriesDetailStatus)  $default,) {final _that = this;
switch (_that) {
case _SeriesState():
return $default(_that.allSeries,_that.seriesDetail,_that.allSeriesStatus,_that.seriesDetailStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SeriesResponse? allSeries,  Series? seriesDetail,  Status allSeriesStatus,  Status seriesDetailStatus)?  $default,) {final _that = this;
switch (_that) {
case _SeriesState() when $default != null:
return $default(_that.allSeries,_that.seriesDetail,_that.allSeriesStatus,_that.seriesDetailStatus);case _:
  return null;

}
}

}

/// @nodoc


class _SeriesState implements SeriesState {
  const _SeriesState({this.allSeries = null, this.seriesDetail = null, this.allSeriesStatus = Status.init, this.seriesDetailStatus = Status.init});
  

@override@JsonKey() final  SeriesResponse? allSeries;
@override@JsonKey() final  Series? seriesDetail;
@override@JsonKey() final  Status allSeriesStatus;
@override@JsonKey() final  Status seriesDetailStatus;

/// Create a copy of SeriesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeriesStateCopyWith<_SeriesState> get copyWith => __$SeriesStateCopyWithImpl<_SeriesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeriesState&&(identical(other.allSeries, allSeries) || other.allSeries == allSeries)&&(identical(other.seriesDetail, seriesDetail) || other.seriesDetail == seriesDetail)&&(identical(other.allSeriesStatus, allSeriesStatus) || other.allSeriesStatus == allSeriesStatus)&&(identical(other.seriesDetailStatus, seriesDetailStatus) || other.seriesDetailStatus == seriesDetailStatus));
}


@override
int get hashCode => Object.hash(runtimeType,allSeries,seriesDetail,allSeriesStatus,seriesDetailStatus);

@override
String toString() {
  return 'SeriesState(allSeries: $allSeries, seriesDetail: $seriesDetail, allSeriesStatus: $allSeriesStatus, seriesDetailStatus: $seriesDetailStatus)';
}


}

/// @nodoc
abstract mixin class _$SeriesStateCopyWith<$Res> implements $SeriesStateCopyWith<$Res> {
  factory _$SeriesStateCopyWith(_SeriesState value, $Res Function(_SeriesState) _then) = __$SeriesStateCopyWithImpl;
@override @useResult
$Res call({
 SeriesResponse? allSeries, Series? seriesDetail, Status allSeriesStatus, Status seriesDetailStatus
});




}
/// @nodoc
class __$SeriesStateCopyWithImpl<$Res>
    implements _$SeriesStateCopyWith<$Res> {
  __$SeriesStateCopyWithImpl(this._self, this._then);

  final _SeriesState _self;
  final $Res Function(_SeriesState) _then;

/// Create a copy of SeriesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allSeries = freezed,Object? seriesDetail = freezed,Object? allSeriesStatus = null,Object? seriesDetailStatus = null,}) {
  return _then(_SeriesState(
allSeries: freezed == allSeries ? _self.allSeries : allSeries // ignore: cast_nullable_to_non_nullable
as SeriesResponse?,seriesDetail: freezed == seriesDetail ? _self.seriesDetail : seriesDetail // ignore: cast_nullable_to_non_nullable
as Series?,allSeriesStatus: null == allSeriesStatus ? _self.allSeriesStatus : allSeriesStatus // ignore: cast_nullable_to_non_nullable
as Status,seriesDetailStatus: null == seriesDetailStatus ? _self.seriesDetailStatus : seriesDetailStatus // ignore: cast_nullable_to_non_nullable
as Status,
  ));
}


}

// dart format on
