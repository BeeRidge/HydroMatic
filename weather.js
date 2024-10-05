document.addEventListener('DOMContentLoaded', async function () {
    const apiKey = 'eb138ac95057191159c149d24e2807a3';
    const city = 'Gapan';
    const weatherForecast = document.getElementById('weather-forecast');

    async function fetchWeatherData() {
        try {
            const response = await fetch(`https://api.openweathermap.org/data/2.5/forecast?q=${city}&units=metric&cnt=40&appid=${apiKey}`);
            if (!response.ok) throw new Error('Network response was not ok');
            const data = await response.json();
            const forecast = data.list;
            const dailyForecast = [];

            forecast.forEach((entry) => {
                const date = new Date(entry.dt_txt).toDateString();
                if (!dailyForecast.some(day => day.date === date)) {
                    dailyForecast.push({
                        date: date,
                        temp: entry.main.temp,
                        icon: `https://openweathermap.org/img/wn/${entry.weather[0].icon}@2x.png`,
                        description: entry.weather[0].description,
                        minTemp: entry.main.temp_min,
                        maxTemp: entry.main.temp_max
                    });
                }
                if (dailyForecast.length >= 5) return;
            });

            weatherForecast.innerHTML = '';
            dailyForecast.forEach((day) => {
                const weatherCard = `
                    <div class="w-full md:w-64 mb-10 shadow-xl duration-500 ease-in-out transform bg-white rounded-lg hover:scale-105 cursor-pointer border flex flex-col justify-center items-center text-center p-6">
                        <div class="text-md font-bold flex flex-col text-gray-900">
                            <span class="uppercase">${new Date(day.date).toLocaleDateString('en-US', { weekday: 'long' })}</span>
                            <span class="font-normal text-gray-700 text-sm">${new Date(day.date).toLocaleDateString('en-US', { month: 'long', day: 'numeric' })}</span>
                        </div>
                        <div class="w-32 h-32 flex items-center justify-center">
                            <img src="${day.icon}" alt="Weather icon" class="w-32 h-32">
                        </div>
                        <p class="text-gray-700 mb-2">${day.description}</p>
                        <div class="text-3xl font-semibold text-gray-900 mb-6">${day.maxTemp.toFixed(1)}º<span class="font-normal text-gray-700 mx-1">/</span>${day.minTemp.toFixed(1)}º</div>
                    </div>
                `;
                weatherForecast.innerHTML += weatherCard;
            });
        } catch (error) {
            weatherForecast.innerHTML = '<p class="text-red-500 font-semibold">Unable to fetch weather data. Please try again later.</p>';
            console.error('Error fetching weather data:', error);
        }
    }

    fetchWeatherData();
});
