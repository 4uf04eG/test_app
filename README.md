# Facts fetcher

1. 20 минут ушло на создание структуры файлов и папок с выбором плагинов, которые понадобятся. В итоге на этой стадии было приложение, которое лишь умеет делать запросы.

2. Час ушло на добавление базы данных и основного экрана с загруженными статьями

3. Так же где-то 20 минут ушло на создание экрана с подробной информацией

4. Два часа ушло на отладку и тестирование с допиливанием мелочей

Основная проблема, наверное, была с тем, как реализовать основной экран.
Была идея совмещать два future в один stream или так же в один future. Но я отказался от этого,
так как стрим в данном случае тяжело контроллировать, ведь мне надо знать какой из списков содержит добавленные факты,
а какой загруженные из интернета, но, если произойдёт какая-то, магия, они могут прийти не в том порядке.
А вариант с одним future такой себе, потому что требует выполнения обоих future.
В итоге я остановился на корявеньком в плане кода, скорости и всего на свете варианте, который just works.

Экран с дополнительной информацией достаточно просто и быстро был готов, проблема лишь была при отладке,
когда я из-за невнимательности не там точку остановки поставил и думал, что FutureBuilder не хочет перестраиваться.

В один момент встал вопрос о том, как с помощью pull-to-refresh факты загружать,
так как в api написано только про один эндпоинт для всех элементов, но на самом сайте был функционал рандомного факта,
который подсказал, что есть ещё эндпоинт random. Я за несколько минут нашёл в коде этот эндпоинт и узнал, что у него можно задавать количество элементов.
Я решил, что лучше использовать его, чем загружать сразу всё, а потом при рефреше отдавать часть.

Компилилось с помощью Flutter 1.20.
