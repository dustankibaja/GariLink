import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

/// Semantic SVG icon data, deliberately distinct from Material IconData.
@immutable
class GariIconData {
  const GariIconData(this.paths, {this.directional = false});
  final List<List<dynamic>> paths;
  final bool directional;
}

/// Stroke Rounded is the single GariLink family. Decorative by default;
/// interactive parents own their tooltip/label and selected/disabled semantics.
class GariIcon extends StatelessWidget {
  const GariIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
    this.strokeWidth = 1.8,
  });
  final GariIconData? icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  final double strokeWidth;
  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final dimension = size ?? theme.size ?? 24;
    Widget child = icon == null
        ? SizedBox.square(dimension: dimension)
        : Center(
            widthFactor: 1,
            heightFactor: 1,
            child: SizedBox.square(
              dimension: dimension,
              child: HugeIcon(
                icon: icon!.paths,
                size: dimension,
                color: color ?? theme.color,
                strokeWidth: strokeWidth,
              ),
            ),
          );
    if (icon?.directional == true &&
        Directionality.of(context) == TextDirection.rtl) {
      child = Transform.flip(flipX: true, child: child);
    }
    return Semantics(
      label: semanticLabel,
      image: semanticLabel != null,
      excludeSemantics: true,
      child: child,
    );
  }
}

class GariLinkIcons {
  GariLinkIcons._();
  static const home = GariIconData(HugeIcons.strokeRoundedHome01);
  static const search = GariIconData(HugeIcons.strokeRoundedSearch01);
  static const trips = GariIconData(HugeIcons.strokeRoundedCalendar03);
  static const profile = GariIconData(HugeIcons.strokeRoundedUserCircle);
  static const menu = GariIconData(HugeIcons.strokeRoundedMenu01);
  static const add = GariIconData(HugeIcons.strokeRoundedAdd01);
  static const addVehicle = GariIconData(HugeIcons.strokeRoundedAddCircle);
  static const bookings = GariIconData(
    HugeIcons.strokeRoundedCalendarCheckIn01,
  );
  static const vehicles = GariIconData(HugeIcons.strokeRoundedCar01);
  static const filter = GariIconData(HugeIcons.strokeRoundedFilterHorizontal);
  static const sort = GariIconData(HugeIcons.strokeRoundedSorting05);
  static const bookmark = GariIconData(HugeIcons.strokeRoundedBookmark01);
  static const savedVehicles = GariIconData(HugeIcons.strokeRoundedFavourite);
  static const share = GariIconData(HugeIcons.strokeRoundedShare08);
  static const back = GariIconData(
    HugeIcons.strokeRoundedArrowLeft02,
    directional: true,
  );
  static const close = GariIconData(HugeIcons.strokeRoundedCancel01);
  static const check = GariIconData(HugeIcons.strokeRoundedTick02);
  static const chevronRight = GariIconData(
    HugeIcons.strokeRoundedArrowRight01,
    directional: true,
  );
  static const moreVert = GariIconData(HugeIcons.strokeRoundedMoreVertical);
  static const notification = GariIconData(
    HugeIcons.strokeRoundedNotification02,
  );
  static const truck = GariIconData(HugeIcons.strokeRoundedTruck);
  static const engine = GariIconData(HugeIcons.strokeRoundedSettings01);
  static const fuel = GariIconData(HugeIcons.strokeRoundedFuelStation);
  static const seats = GariIconData(HugeIcons.strokeRoundedAirplaneSeat);
  static const transmission = GariIconData(HugeIcons.strokeRoundedTransmission);
  static const speedometer = GariIconData(
    HugeIcons.strokeRoundedDashboardSpeed01,
  );
  static const garage = GariIconData(HugeIcons.strokeRoundedGarage);
  static const tools = GariIconData(HugeIcons.strokeRoundedWrench01);
  static const location = GariIconData(HugeIcons.strokeRoundedLocation01);
  static const earnings = GariIconData(HugeIcons.strokeRoundedMoney03);
  static const analytics = GariIconData(HugeIcons.strokeRoundedAnalytics01);
  static const listings = GariIconData(HugeIcons.strokeRoundedTask01);
  static const requests = GariIconData(HugeIcons.strokeRoundedInbox);
  static const team = GariIconData(HugeIcons.strokeRoundedUserGroup);
  static const subscription = GariIconData(HugeIcons.strokeRoundedAward01);
  static const payments = GariIconData(HugeIcons.strokeRoundedCreditCard);
  static const help = GariIconData(HugeIcons.strokeRoundedHelpCircle);
  static const logout = GariIconData(
    HugeIcons.strokeRoundedLogout01,
    directional: true,
  );
  static const verifiedBadge = GariIconData(
    HugeIcons.strokeRoundedCheckmarkBadge01,
  );
  static const businessProfile = GariIconData(HugeIcons.strokeRoundedOffice);
  static const contactSupport = GariIconData(
    HugeIcons.strokeRoundedCustomerSupport,
  );
  static const feedback = GariIconData(HugeIcons.strokeRoundedComment01);
  static const map = GariIconData(HugeIcons.strokeRoundedMapsLocation01);
  static const navigation = GariIconData(
    HugeIcons.strokeRoundedNavigation01,
    directional: true,
  );
  static const starFilled = GariIconData(HugeIcons.strokeRoundedStar);
  static const starHalf = GariIconData(HugeIcons.strokeRoundedStarHalf);
  static const starEmpty = GariIconData(HugeIcons.strokeRoundedStar);
  static const message = GariIconData(HugeIcons.strokeRoundedMessage01);
  static const phone = GariIconData(HugeIcons.strokeRoundedCall);
  static const clock = GariIconData(HugeIcons.strokeRoundedClock01);
  static const confirmed = GariIconData(
    HugeIcons.strokeRoundedCheckmarkCircle02,
  );
  static const pending = GariIconData(HugeIcons.strokeRoundedHourglass);
  static const cancelled = GariIconData(HugeIcons.strokeRoundedCancelCircle);
  static const ongoing = GariIconData(HugeIcons.strokeRoundedPlayCircle);
  static const photo = GariIconData(HugeIcons.strokeRoundedImage01);
  static const addPhoto = GariIconData(HugeIcons.strokeRoundedImageAdd01);
  static const calculate = GariIconData(HugeIcons.strokeRoundedCalculator01);
  static const cloudOff = GariIconData(HugeIcons.strokeRoundedCloudOff);
  static const upload = GariIconData(HugeIcons.strokeRoundedCloudUpload);
  static const dashboard = GariIconData(
    HugeIcons.strokeRoundedDashboardSquare01,
  );
  static const delete = GariIconData(HugeIcons.strokeRoundedDelete02);
  static const edit = GariIconData(HugeIcons.strokeRoundedEdit02);
  static const error = GariIconData(HugeIcons.strokeRoundedAlertCircle);
  static const explore = GariIconData(HugeIcons.strokeRoundedCompass01);
  static const flag = GariIconData(HugeIcons.strokeRoundedFlag01);
  static const info = GariIconData(HugeIcons.strokeRoundedInformationCircle);
  static const cargo = GariIconData(HugeIcons.strokeRoundedPackage);
  static const key = GariIconData(HugeIcons.strokeRoundedKey01);
  static const linkOff = GariIconData(HugeIcons.strokeRoundedUnlink01);
  static const lockClock = GariIconData(HugeIcons.strokeRoundedLockKey);
  static const myLocation = GariIconData(HugeIcons.strokeRoundedGps01);
  static const moon = GariIconData(HugeIcons.strokeRoundedMoon02);
  static const refresh = GariIconData(HugeIcons.strokeRoundedRefresh);
  static const route = GariIconData(HugeIcons.strokeRoundedRoute01);
  static const save = GariIconData(HugeIcons.strokeRoundedFloppyDisk);
  static const searchOff = GariIconData(HugeIcons.strokeRoundedSearchRemove);
  static const timerOff = GariIconData(HugeIcons.strokeRoundedTimer02);
  static const visibility = GariIconData(HugeIcons.strokeRoundedView);
  static const visibilityOff = GariIconData(HugeIcons.strokeRoundedViewOff);
  static const arrowDown = GariIconData(HugeIcons.strokeRoundedArrowDown01);
  static const arrowUp = GariIconData(HugeIcons.strokeRoundedArrowUp01);
  static const homeActive = home;
  static const tripsActive = trips;
  static const profileActive = profile;
  static const bookingsActive = bookings;
  static const vehiclesActive = vehicles;
  static const bookmarkFilled = bookmark;
  static const notificationActive = notification;
  static const suv = vehicles;
  static const sedan = vehicles;
  static const pickup = truck;
  static const rent = vehicles;
  static const spareParts = tools;
  static const track = location;
  static const diy = tools;
  static const personalInfo = profile;
  static const paymentMethods = payments;
  static const settings = engine;
  static const calendar = trips;
  static const completedIcon = confirmed;
}
