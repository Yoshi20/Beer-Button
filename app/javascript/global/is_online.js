export const isOnline = async () => {
  if (!window.navigator.onLine) return false;
  try {
    const response = await fetch("/1pixel.png")
    return response.ok;
  } catch (err) {
    return false;
  }
};


export default {
  isOnline,
};
