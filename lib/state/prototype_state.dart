import 'app_facility_state.dart';
import 'app_membership_state.dart';
import 'app_session.dart';
import 'app_booking_state.dart';
import 'app_catalogue_state.dart';
import 'app_rental_state.dart';

abstract final class PrototypeState {
  static void reset() {
    AppSession.reset();
    AppFacilityState.reset();
    AppMembershipState.reset();
    AppBookingState.reset();
    AppCatalogueState.reset();
    AppRentalState.reset();
  }
}
