import { useState } from 'react';

interface SafeImageProps {
  src: string;
  alt: string;
  className?: string;
  eager?: boolean;
}

export function SafeImage({ src, alt, className, eager = false }: SafeImageProps) {
  const [failed, setFailed] = useState(false);

  if (failed) {
    return <div className={`${className ?? ''} safe-image--fallback`} role="img" aria-label={alt} />;
  }

  return (
    <img
      className={className}
      src={src}
      alt={alt}
      loading={eager ? 'eager' : 'lazy'}
      decoding="async"
      onError={() => setFailed(true)}
    />
  );
}
