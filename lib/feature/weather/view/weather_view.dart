import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/feature/weather/data/city_data.dart';
import 'package:weather_app/feature/weather/data/weather_data.dart';
import 'package:weather_app/feature/weather/view_model/weather_view_model.dart';
import 'package:weather_app/shared/app_theme.dart';

/// This view can display weather information.
class WeatherView extends StatefulWidget {
  const WeatherView({super.key, required this.viewModel});

  /// The corresponding view model of [WeatherView].
  final WeatherViewModel viewModel;

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.initialize();
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        Widget body;
        final status = widget.viewModel.status;
        if (status is WeatherViewModelLoadingStatus) {
          body = const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  'Fetching weather data...',
                  style: AppTheme.textStyleBody1,
                ),
              ],
            ),
          );
        } else if (status is WeatherViewModelErrorStatus) {
          body = Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Could not fetch weather data.',
                  style: AppTheme.textStyleBody1,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await widget.viewModel.refreshWeatherData(
                      cityData: status.selectedCityData,
                      cityDataList: status.cityDataList,
                      setLoadingStatus: true,
                    );
                  },
                  child: const Text('Try again'),
                ),
              ],
            ),
          );
        } else if (status is WeatherViewModelLoadedStatus) {
          body = _LoadedContent(
            viewModel: widget.viewModel,
            status: status,
          );
        } else {
          throw '[_WeatherViewState.build] unknown status ${status.runtimeType}';
        }
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: body,
          ),
        );
      },
    );
  }
}

class _LoadedContent extends StatelessWidget {
  const _LoadedContent({required this.viewModel, required this.status});

  final WeatherViewModel viewModel;
  final WeatherViewModelLoadedStatus status;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await viewModel.refreshWeatherData(
          cityData: status.selectedCityData,
          cityDataList: status.cityDataList,
          oldWeatherData: status.selectedWeatherData,
          setLoadingStatus: false,
        );
        if (context.mounted && viewModel.status is WeatherViewModelLoadedStatus) {
          const snackBar = SnackBar(
            content: Text('Weather data updated successfully.'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTheme.topViewSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.horizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE').format(status.selectedWeatherData.time),
                        style: AppTheme.textStyleHeadline3,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        DateFormat('d MMM y').format(status.selectedWeatherData.time),
                        style: AppTheme.textStyleSubtitle1.copyWith(
                          color: AppTheme.colorUnselected,
                        ),
                      ),
                      const SizedBox(height: 34),
                      PopupMenuButton<CityData>(
                        onSelected: (CityData cityData) {
                          viewModel.selectCityData(cityData, status);
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<CityData>>[
                          for (final cityData in status.cityDataList)
                            PopupMenuItem<CityData>(
                              value: cityData,
                              child: Text(cityData.name),
                            ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            boxShadow: AppTheme.boxShadow,
                            borderRadius: BorderRadius.circular(5),
                            color: AppTheme.colorLightFont,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: AppTheme.colorIcon,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                status.selectedCityData.name,
                                style: AppTheme.textStyleSubtitle1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        status.selectedWeatherData.values.temperatureAvg.round().toString(),
                        style: AppTheme.textStyleHeadline1,
                      ),
                      const Text('°', style: AppTheme.textStyleHeadline2),
                    ],
                  ),
                ),
                const Spacer(),
                const _Divider(),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.horizontalPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Metric(
                        title: 'Humidity',
                        value: status.selectedWeatherData.values.humidityAvg,
                        unit: '%',
                      ),
                      _Metric(
                        title: 'Pressure',
                        value: status.selectedWeatherData.values.pressureSurfaceLevelAvg,
                        unit: 'hPa',
                      ),
                      _Metric(
                        title: 'Wind',
                        value: status.selectedWeatherData.values.windSpeedAvg,
                        unit: 'km/h',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const _Divider(),
                const Spacer(),
                SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: AppTheme.horizontalPadding),
                      for (final weatherData in status.weatherDataList)
                        _WeatherButton(
                          weatherData: weatherData,
                          selected: weatherData == status.selectedWeatherData,
                          onPressed: () {
                            viewModel.selectWeatherData(weatherData, status);
                          },
                        ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppTheme.colorLightFont,
      thickness: 2,
      height: 0,
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.title,
    required this.value,
    required this.unit,
  });

  final String title;
  final double value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: AppTheme.textStyleSubtitle1.copyWith(
            color: AppTheme.colorUnselected,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              value.round().toString(),
              style: AppTheme.textStyleBody1,
            ),
            Text(
              ' $unit',
              style: AppTheme.textStyleBody2,
            ),
          ],
        ),
      ],
    );
  }
}

class _WeatherButton extends StatelessWidget {
  const _WeatherButton({
    required this.weatherData,
    required this.selected,
    required this.onPressed,
  });

  final WeatherData weatherData;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTheme.textStyleHeadline4.copyWith(
      color: selected ? AppTheme.colorOnSelected : null,
    );
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 31,
          vertical: 10,
        ),
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          boxShadow: AppTheme.boxShadow,
          borderRadius: BorderRadius.circular(5),
          color: selected ? AppTheme.colorSelected : AppTheme.colorLightFont,
        ),
        child: Column(
          children: [
            Text(
              DateFormat('EEE').format(weatherData.time),
              style: textStyle,
            ),
            const SizedBox(height: 15),
            Text(
              '${weatherData.values.temperatureMin.round()}°/${weatherData.values.temperatureMax.round()}°',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
