<?php

for ($i = 1; $i <= 100; ++$i) {
    $i3 = $i % 3 == 0;
    $i5 = $i % 5 == 0;

    if (!$i3 && !$i5) {
        echo "$i";
    } else {
        if ($i3) echo 'Чих';
        if ($i5) echo 'Пых';
    }

    echo "\n";
}
