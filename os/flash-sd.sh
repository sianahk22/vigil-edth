#!/usr/bin/env bash
# Écrit Ubuntu 24.04.5 Desktop (Raspberry Pi) sur la carte SD /dev/sda.
# ATTENTION : efface TOUT le contenu de /dev/sda.
# Le script s'arrête avant d'écrire si une seule vérification échoue.
set -euo pipefail

IMG="$HOME/vigil-edth/os/ubuntu-24.04.5-preinstalled-desktop-arm64+raspi.img.xz"
SHA="f4a333eccfda8f1ae01a03da5ba6effb52fe32becc7dde27dc9a269200ac823a"
DEV="/dev/sda"

echo "1/5 Vérification de l'intégrité de l'image (SHA-256)..."
[ -f "$IMG" ] || { echo "ERREUR : image introuvable (téléchargement pas fini ?)"; exit 1; }
echo "$SHA  $IMG" | sha256sum -c --quiet - || { echo "ERREUR : image corrompue ou incomplète"; exit 1; }

echo "2/5 Vérification de la cible $DEV..."
[ "$(lsblk -dno RM "$DEV")" = "1" ] || { echo "ERREUR : $DEV n'est pas un disque amovible"; exit 1; }
[ "$(lsblk -dno TRAN "$DEV")" = "usb" ] || { echo "ERREUR : $DEV n'est pas branché en USB"; exit 1; }
SIZE=$(lsblk -bdno SIZE "$DEV")
if [ "$SIZE" -lt 30000000000 ] || [ "$SIZE" -gt 70000000000 ]; then
  echo "ERREUR : taille inattendue ($SIZE octets)"; exit 1
fi
if lsblk -no MOUNTPOINT "$DEV" | grep -qE '^/$|^/boot|^/home'; then
  echo "ERREUR : $DEV contient le système, abandon"; exit 1
fi
lsblk -o NAME,SIZE,MODEL,TRAN,MOUNTPOINT "$DEV"

read -r -p "3/5 Tout le contenu de $DEV va être EFFACÉ. Tape OUI pour continuer : " REP
[ "$REP" = "OUI" ] || { echo "Annulé."; exit 1; }

echo "4/5 Démontage des partitions de la carte..."
for p in $(lsblk -lno NAME "$DEV" | tail -n +2); do
  sudo umount "/dev/$p" 2>/dev/null || true
done

echo "5/5 Écriture de l'image (plusieurs minutes)..."
xzcat "$IMG" | sudo dd of="$DEV" bs=4M status=progress conv=fsync
sync
echo "TERMINÉ. Tu peux retirer la carte SD et la mettre dans le Raspberry Pi 5."
