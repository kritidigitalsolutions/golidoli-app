// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EpisodeEvent {

 String get id;
/// Create a copy of EpisodeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeEventCopyWith<EpisodeEvent> get copyWith => _$EpisodeEventCopyWithImpl<EpisodeEvent>(this as EpisodeEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpisodeEvent&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'EpisodeEvent(id: $id)';
}


}

/// @nodoc
abstract mixin class $EpisodeEventCopyWith<$Res>  {
  factory $EpisodeEventCopyWith(EpisodeEvent value, $Res Function(EpisodeEvent) _then) = _$EpisodeEventCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$EpisodeEventCopyWithImpl<$Res>
    implements $EpisodeEventCopyWith<$Res> {
  _$EpisodeEventCopyWithImpl(this._self, this._then);

  final EpisodeEvent _self;
  final $Res Function(EpisodeEvent) _then;

/// Create a copy of EpisodeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EpisodeEvent].
extension EpisodeEventPatterns on EpisodeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AllEpisode value)?  allEpisode,TResult Function( _EpisodeDetail value)?  episodeDetail,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AllEpisode() when allEpisode != null:
return allEpisode(_that);case _EpisodeDetail() when episodeDetail != null:
return episodeDetail(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AllEpisode value)  allEpisode,required TResult Function( _EpisodeDetail value)  episodeDetail,}){
final _that = this;
switch (_that) {
case _AllEpisode():
return allEpisode(_that);case _EpisodeDetail():
return episodeDetail(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AllEpisode value)?  allEpisode,TResult? Function( _EpisodeDetail value)?  episodeDetail,}){
final _that = this;
switch (_that) {
case _AllEpisode() when allEpisode != null:
return allEpisode(_that);case _EpisodeDetail() when episodeDetail != null:
return episodeDetail(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id)?  allEpisode,TResult Function( String id)?  episodeDetail,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AllEpisode() when allEpisode != null:
return allEpisode(_that.id);case _EpisodeDetail() when episodeDetail != null:
return episodeDetail(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id)  allEpisode,required TResult Function( String id)  episodeDetail,}) {final _that = this;
switch (_that) {
case _AllEpisode():
return allEpisode(_that.id);case _EpisodeDetail():
return episodeDetail(_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id)?  allEpisode,TResult? Function( String id)?  episodeDetail,}) {final _that = this;
switch (_that) {
case _AllEpisode() when allEpisode != null:
return allEpisode(_that.id);case _EpisodeDetail() when episodeDetail != null:
return episodeDetail(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _AllEpisode implements EpisodeEvent {
  const _AllEpisode({required this.id});
  

@override final  String id;

/// Create a copy of EpisodeEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AllEpisodeCopyWith<_AllEpisode> get copyWith => __$AllEpisodeCopyWithImpl<_AllEpisode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllEpisode&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'EpisodeEvent.allEpisode(id: $id)';
}


}

/// @nodoc
abstract mixin class _$AllEpisodeCopyWith<$Res> implements $EpisodeEventCopyWith<$Res> {
  factory _$AllEpisodeCopyWith(_AllEpisode value, $Res Function(_AllEpisode) _then) = __$AllEpisodeCopyWithImpl;
@override @useResult
$Res call({
 String id
});




}
/// @nodoc
class __$AllEpisodeCopyWithImpl<$Res>
    implements _$AllEpisodeCopyWith<$Res> {
  __$AllEpisodeCopyWithImpl(this._self, this._then);

  final _AllEpisode _self;
  final $Res Function(_AllEpisode) _then;

/// Create a copy of EpisodeEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_AllEpisode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _EpisodeDetail implements EpisodeEvent {
  const _EpisodeDetail({required this.id});
  

@override final  String id;

/// Create a copy of EpisodeEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeDetailCopyWith<_EpisodeDetail> get copyWith => __$EpisodeDetailCopyWithImpl<_EpisodeDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpisodeDetail&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'EpisodeEvent.episodeDetail(id: $id)';
}


}

/// @nodoc
abstract mixin class _$EpisodeDetailCopyWith<$Res> implements $EpisodeEventCopyWith<$Res> {
  factory _$EpisodeDetailCopyWith(_EpisodeDetail value, $Res Function(_EpisodeDetail) _then) = __$EpisodeDetailCopyWithImpl;
@override @useResult
$Res call({
 String id
});




}
/// @nodoc
class __$EpisodeDetailCopyWithImpl<$Res>
    implements _$EpisodeDetailCopyWith<$Res> {
  __$EpisodeDetailCopyWithImpl(this._self, this._then);

  final _EpisodeDetail _self;
  final $Res Function(_EpisodeDetail) _then;

/// Create a copy of EpisodeEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_EpisodeDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$EpisodeState {

 EpisodesResponse? get allEpisode; Status get allEpisodeStatus; Status get detailEpisode; EpisodeModel? get episodeDetail;
/// Create a copy of EpisodeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeStateCopyWith<EpisodeState> get copyWith => _$EpisodeStateCopyWithImpl<EpisodeState>(this as EpisodeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpisodeState&&(identical(other.allEpisode, allEpisode) || other.allEpisode == allEpisode)&&(identical(other.allEpisodeStatus, allEpisodeStatus) || other.allEpisodeStatus == allEpisodeStatus)&&(identical(other.detailEpisode, detailEpisode) || other.detailEpisode == detailEpisode)&&(identical(other.episodeDetail, episodeDetail) || other.episodeDetail == episodeDetail));
}


@override
int get hashCode => Object.hash(runtimeType,allEpisode,allEpisodeStatus,detailEpisode,episodeDetail);

@override
String toString() {
  return 'EpisodeState(allEpisode: $allEpisode, allEpisodeStatus: $allEpisodeStatus, detailEpisode: $detailEpisode, episodeDetail: $episodeDetail)';
}


}

/// @nodoc
abstract mixin class $EpisodeStateCopyWith<$Res>  {
  factory $EpisodeStateCopyWith(EpisodeState value, $Res Function(EpisodeState) _then) = _$EpisodeStateCopyWithImpl;
@useResult
$Res call({
 EpisodesResponse? allEpisode, Status allEpisodeStatus, Status detailEpisode, EpisodeModel? episodeDetail
});




}
/// @nodoc
class _$EpisodeStateCopyWithImpl<$Res>
    implements $EpisodeStateCopyWith<$Res> {
  _$EpisodeStateCopyWithImpl(this._self, this._then);

  final EpisodeState _self;
  final $Res Function(EpisodeState) _then;

/// Create a copy of EpisodeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allEpisode = freezed,Object? allEpisodeStatus = null,Object? detailEpisode = null,Object? episodeDetail = freezed,}) {
  return _then(_self.copyWith(
allEpisode: freezed == allEpisode ? _self.allEpisode : allEpisode // ignore: cast_nullable_to_non_nullable
as EpisodesResponse?,allEpisodeStatus: null == allEpisodeStatus ? _self.allEpisodeStatus : allEpisodeStatus // ignore: cast_nullable_to_non_nullable
as Status,detailEpisode: null == detailEpisode ? _self.detailEpisode : detailEpisode // ignore: cast_nullable_to_non_nullable
as Status,episodeDetail: freezed == episodeDetail ? _self.episodeDetail : episodeDetail // ignore: cast_nullable_to_non_nullable
as EpisodeModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [EpisodeState].
extension EpisodeStatePatterns on EpisodeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpisodeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpisodeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpisodeState value)  $default,){
final _that = this;
switch (_that) {
case _EpisodeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpisodeState value)?  $default,){
final _that = this;
switch (_that) {
case _EpisodeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EpisodesResponse? allEpisode,  Status allEpisodeStatus,  Status detailEpisode,  EpisodeModel? episodeDetail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpisodeState() when $default != null:
return $default(_that.allEpisode,_that.allEpisodeStatus,_that.detailEpisode,_that.episodeDetail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EpisodesResponse? allEpisode,  Status allEpisodeStatus,  Status detailEpisode,  EpisodeModel? episodeDetail)  $default,) {final _that = this;
switch (_that) {
case _EpisodeState():
return $default(_that.allEpisode,_that.allEpisodeStatus,_that.detailEpisode,_that.episodeDetail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EpisodesResponse? allEpisode,  Status allEpisodeStatus,  Status detailEpisode,  EpisodeModel? episodeDetail)?  $default,) {final _that = this;
switch (_that) {
case _EpisodeState() when $default != null:
return $default(_that.allEpisode,_that.allEpisodeStatus,_that.detailEpisode,_that.episodeDetail);case _:
  return null;

}
}

}

/// @nodoc


class _EpisodeState implements EpisodeState {
  const _EpisodeState({this.allEpisode = null, this.allEpisodeStatus = Status.init, this.detailEpisode = Status.init, this.episodeDetail = null});
  

@override@JsonKey() final  EpisodesResponse? allEpisode;
@override@JsonKey() final  Status allEpisodeStatus;
@override@JsonKey() final  Status detailEpisode;
@override@JsonKey() final  EpisodeModel? episodeDetail;

/// Create a copy of EpisodeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeStateCopyWith<_EpisodeState> get copyWith => __$EpisodeStateCopyWithImpl<_EpisodeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpisodeState&&(identical(other.allEpisode, allEpisode) || other.allEpisode == allEpisode)&&(identical(other.allEpisodeStatus, allEpisodeStatus) || other.allEpisodeStatus == allEpisodeStatus)&&(identical(other.detailEpisode, detailEpisode) || other.detailEpisode == detailEpisode)&&(identical(other.episodeDetail, episodeDetail) || other.episodeDetail == episodeDetail));
}


@override
int get hashCode => Object.hash(runtimeType,allEpisode,allEpisodeStatus,detailEpisode,episodeDetail);

@override
String toString() {
  return 'EpisodeState(allEpisode: $allEpisode, allEpisodeStatus: $allEpisodeStatus, detailEpisode: $detailEpisode, episodeDetail: $episodeDetail)';
}


}

/// @nodoc
abstract mixin class _$EpisodeStateCopyWith<$Res> implements $EpisodeStateCopyWith<$Res> {
  factory _$EpisodeStateCopyWith(_EpisodeState value, $Res Function(_EpisodeState) _then) = __$EpisodeStateCopyWithImpl;
@override @useResult
$Res call({
 EpisodesResponse? allEpisode, Status allEpisodeStatus, Status detailEpisode, EpisodeModel? episodeDetail
});




}
/// @nodoc
class __$EpisodeStateCopyWithImpl<$Res>
    implements _$EpisodeStateCopyWith<$Res> {
  __$EpisodeStateCopyWithImpl(this._self, this._then);

  final _EpisodeState _self;
  final $Res Function(_EpisodeState) _then;

/// Create a copy of EpisodeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allEpisode = freezed,Object? allEpisodeStatus = null,Object? detailEpisode = null,Object? episodeDetail = freezed,}) {
  return _then(_EpisodeState(
allEpisode: freezed == allEpisode ? _self.allEpisode : allEpisode // ignore: cast_nullable_to_non_nullable
as EpisodesResponse?,allEpisodeStatus: null == allEpisodeStatus ? _self.allEpisodeStatus : allEpisodeStatus // ignore: cast_nullable_to_non_nullable
as Status,detailEpisode: null == detailEpisode ? _self.detailEpisode : detailEpisode // ignore: cast_nullable_to_non_nullable
as Status,episodeDetail: freezed == episodeDetail ? _self.episodeDetail : episodeDetail // ignore: cast_nullable_to_non_nullable
as EpisodeModel?,
  ));
}


}

// dart format on
